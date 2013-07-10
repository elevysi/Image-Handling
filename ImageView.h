//
//  ImageView.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageData.h"

/*
 Defining the various view modes
 */
typedef enum {
    normalMode,
    selectToolMode,
    cropToolMode,
} toolMode;

@interface ImageView : NSView
{
    ImageData               *_imageData;
    
    NSPoint                 _downPoint;
    NSPoint                 _currentPoint;
    
    toolMode                _currentToolMode;
    
    BOOL                    _isCurrentSselectionDisplayed;
    
    NSRect                  _currentSelectedRect;

    
    NSRect                  _offScreenCurrentSelection;
    NSRect                  _offScreenRectToCrop;
    
    BOOL                    _isFilterApplied;
    BOOL                    _isCropped;
    
    
}

@property (strong) ImageData*               imageData;
@property () toolMode                       currentToolMode;
@property () NSRect                         currentSelectedRect;
@property () BOOL                           isCurrentSselectionDisplayed;
@property () BOOL                           isFilterApplied;
@property () BOOL                           isCropped;
@property () NSRect                         offScreenCurrentSelection;

- (NSRect) makeRectFromSelection;
- (CGRect) rectangleToCrop;

- (NSAffineTransform *) transformViewForImage:(CIImage *)image;
- (void)drawCGImageRef:(CGImageRef)image;


@end
