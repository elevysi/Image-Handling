//
//  ImageView.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "ImageView.h"
#import <Quartz/Quartz.h>

@implementation ImageView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        self.currentToolMode = normalMode;
        self.isCurrentSselectionDisplayed = NO;
        self.isFilterApplied = NO;
        self.isCropped = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.imageData && !self.isFilterApplied)
    {
        [self drawCIImage:self.imageData.ciImage];
//        [self drawCGImageRef:self.imageData.cgImageRef];
    }
    
    if (self.imageData && (self.currentToolMode == selectToolMode))
    {
        [NSGraphicsContext saveGraphicsState];
        [[NSColor greenColor] set];
        [NSBezierPath strokeRect:self.currentSelectedRect];
        [NSGraphicsContext restoreGraphicsState];
        self.isCurrentSselectionDisplayed = YES;
    }
    if (self.isFilterApplied) {
        CIImage *image = [self.imageData imageWithFilter:self.imageData.ciImage inView:self];
        [self drawCIImage:image];
    }
    if (self.isCropped) {
        NSLog(@"Drawing Mask");
        [self drawCGImageRef:self.imageData.cgImageRef];
    }
}

- (void) drawCIImage:(CIImage *)image
{

        [NSGraphicsContext saveGraphicsState];
        [[self transformViewForImage:image] concat];
        CIContext *context = [CIContext contextWithCGContext:
                              [[NSGraphicsContext currentContext] graphicsPort]
                                                     options: nil];
        [context drawImage:image
                    inRect:[self.imageData getDestinationRectForImage:self.imageData.ciImage FromView:self]
                  fromRect:[image extent]];
    
        [NSGraphicsContext restoreGraphicsState];
}

- (void)drawCGImageRef:(CGImageRef)image
{
//    // Drawing code here.
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];

    CGContextDrawImage(context, [self bounds], image);
}


- (NSAffineTransform *) transformViewForImage:(CIImage *)image
{
    [self.imageData setScalefactorForImage:image FromViewFrame:[self bounds]];
    CGRect finalRect = [self.imageData getDestinationRectForImage:image FromView:self];
    /*
     Scale the view to the coordinate of the Image
     Useful to crop
     */
    CGRect targetRect = [self bounds];
    
    CGFloat xTranslate = (targetRect.size.width - finalRect.size.width) * 0.5;
    CGFloat yTranslate = (targetRect.size.height - finalRect.size.height) * 0.5;
    
    /*
     The view coordinate has to be transformed and translated to the Image Coordinate
     */
    NSAffineTransform *xform = [NSAffineTransform transform];
    [xform translateXBy:xTranslate yBy:yTranslate];
    return xform;
}

#pragma mark -
#pragma mark Mouse Events

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    _downPoint = [self convertPoint:p fromView:nil];
    _currentPoint = _downPoint;
    [self makeRectFromSelection];
    [self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    NSPoint     p = [theEvent locationInWindow];
    _currentPoint = [self convertPoint:p fromView:nil];
    [self autoscroll:theEvent];
    [self makeRectFromSelection];
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent
{
    NSPoint     p = [theEvent locationInWindow];
    _currentPoint = [self convertPoint:p fromView:nil];
    [self makeRectFromSelection];
    [self setNeedsDisplay:YES];
}


#pragma mark -
#pragma mark Selected Rect

- (NSRect) makeRectFromSelection
{
    float minX = MIN(_downPoint.x, _currentPoint.x);
    float maxX = MAX(_downPoint.x, _currentPoint.x);
    float minY = MIN(_downPoint.y, _currentPoint.y);
    float maxY = MAX(_downPoint.y, _currentPoint.y);
    
    _currentSelectedRect = NSMakeRect(minX, minY, maxX-minX, maxY-minY);
    return _currentSelectedRect;
    
}

- (CGRect) rectangleToCrop
{
    CGFloat theXOrigin = (_currentSelectedRect.origin.x) * (1 / self.imageData.scalefactor);
    CGFloat theYOrigin = (_currentSelectedRect.origin.y) * (1 / self.imageData.scalefactor);
    
    CGFloat theWidth = (_currentSelectedRect.size.width) * (1 / self.imageData.scalefactor);
    CGFloat theHeight = (_currentSelectedRect.size.height) * (1 / self.imageData.scalefactor);
    
    _offScreenCurrentSelection = NSMakeRect(theXOrigin, theYOrigin, theWidth, theHeight);
    
    self.offScreenCurrentSelection = _offScreenCurrentSelection;
    
    return self.offScreenCurrentSelection;
}

- (BOOL) isFlipped
{
    return NO;
}

@end
