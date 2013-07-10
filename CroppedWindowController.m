//
//  CroppedWindowController.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/20/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "CroppedWindowController.h"

@interface CroppedWindowController ()

@end

@implementation CroppedWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id) initWithWindowNibName:(NSString *)windowNibName andCGImageRef:(CGImageRef)imageRef
{
    if (self = [super initWithWindowNibName:windowNibName]) {
        NSRect viewFrame = [self.window.contentView bounds];
        
        
        self.imageView = [[ImageView alloc] initWithFrame:viewFrame];
        
        NSInteger resizingMask = ( NSViewWidthSizable | NSViewHeightSizable );
        
        [self.imageView setAutoresizingMask:resizingMask];
        [self.window.contentView addSubview:self.imageView];
        
        self.imageData = [[ImageData alloc] initWithCGImageRef:imageRef];
        
        /*
         Give the image data to the View
         */
        self.imageView.imageData = self.imageData;
        
        [self.imageView setNeedsDisplay:YES];
        
        
        
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(handleNotitfication:)
                                   name:@"SelectedTool"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getXOriginFromSelectionInspector:)
                                   name:@"RectangleXOrigin"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getYOriginFromSelectionInspector:)
                                   name:@"RectangleYOrigin"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getWidthFromSelectionInspector:)
                                   name:@"RectangleWidth"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getHeightFromSelectionInspector:)
                                   name:@"RectangleHeight"
                                 object:nil];
        
        
        /*
         Properties Notifications
         */
        [notificationCenter addObserver:self
                               selector:@selector(getExposureValue:)
                                   name:@"ExposureValue2"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getSaturationValue:)
                                   name:@"SaturationValue2"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getHueValue:)
                                   name:@"HueValue2"
                                 object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Show Inspectors


- (IBAction)showToolsInspector:(id)sender
{
    if (!tools) {
        tools = [[ToolInspector alloc] initWithWindowNibName:@"ToolInspector"];
    }
    [tools showWindow:self];
}

- (IBAction)showSelectionInspector:(id)sender
{
    if (!(selectionInspector) && self.imageView.currentToolMode == selectToolMode)
    {
        selectionInspector = [[SelectionInspector alloc]
                              initWithWindowNibName:@"SelectionInspector" andRectangle:self.imageView.currentSelectedRect];
    }
    [selectionInspector showWindow:self];
}

- (IBAction)showPropertiesInspector:(id)sender
{
    if (!propertiesController && self.imageData)
    {
        propertiesController = [[PropertyInspector alloc] initWithWindowNibName:@"PropertyInspector"];
    }
    [propertiesController showWindow:self];
}





#pragma mark -
#pragma mark Handle Tools Inspector Notifications


- (void) handleNotitfication:(NSNotification *)_notification
{
    NSUInteger theTag = [[_notification object] tag];
    if (theTag == 0)
        self.imageView.currentToolMode = selectToolMode;
}



#pragma mark -
#pragma mark Handle Selector Inspector Notifications


- (void) getXOriginFromSelectionInspector:(NSNotification *)_notification
{
    float theXOrigin = [[_notification object] floatValue];
    float theYOrigin = self.imageView.currentSelectedRect.origin.y;
    float theWidth = self.imageView.currentSelectedRect.size.width;
    float theHeight = self.imageView.currentSelectedRect.size.height;
    self.imageView.currentSelectedRect = NSMakeRect(theXOrigin,
                                                    theYOrigin,
                                                    theWidth,
                                                    theHeight);
    [self.imageView setNeedsDisplay:YES];
    
}

- (void)getYOriginFromSelectionInspector:(NSNotification *)_notification
{
    float theYOrigin = [[_notification object] floatValue];
    
    float theXOrigin = self.imageView.currentSelectedRect.origin.x;
    float theWidth = self.imageView.currentSelectedRect.size.width;
    float theHeight = self.imageView.currentSelectedRect.size.height;
    
    self.imageView.currentSelectedRect = NSMakeRect(theXOrigin,
                                                    theYOrigin,
                                                    theWidth,
                                                    theHeight);
    
    [self.imageView setNeedsDisplay:YES];
}

- (void)getWidthFromSelectionInspector:(NSNotification *)_notification
{
    float theWidth = [[_notification object] floatValue];
    
    float theXOrigin = self.imageView.currentSelectedRect.origin.x;
    float theYOrigin = self.imageView.currentSelectedRect.origin.y;
    float theHeight = self.imageView.currentSelectedRect.size.height;
    
    self.imageView.currentSelectedRect = NSMakeRect(theXOrigin,
                                                    theYOrigin,
                                                    theWidth,
                                                    theHeight);
    
    [self.imageView setNeedsDisplay:YES];
}

- (void)getHeightFromSelectionInspector:(NSNotification *)_notification
{
    float theHeight = [[_notification object] floatValue];
    
    float theXOrigin = self.imageView.currentSelectedRect.origin.x;
    float theYOrigin = self.imageView.currentSelectedRect.origin.y;
    float theWidth = self.imageView.currentSelectedRect.size.width;
    
    self.imageView.currentSelectedRect = NSMakeRect(theXOrigin,
                                                    theYOrigin,
                                                    theWidth,
                                                    theHeight);
    [self.imageView setNeedsDisplay:YES];
}




#pragma mark -
#pragma mark Handle Property Inspector Notifications


- (void)getExposureValue:(NSNotification *)_notification
{
    NSNumber * exposureValue = [_notification object];
    [self.imageData setExposureValue:exposureValue];
    self.imageView.isFilterApplied = YES;
    [self.imageView setNeedsDisplay:YES];
    
}

- (void) getSaturationValue:(NSNotification *)_notification
{
    NSNumber * saturationValue = [_notification object];
    [self.imageData setSaturationValue:saturationValue];
    self.imageView.isFilterApplied = YES;
    [self.imageView setNeedsDisplay:YES];
}
- (void) getHueValue:(NSNotification *)_notification
{
    NSNumber *hueValue = [_notification object];
    [self.imageData setHueValue:hueValue];
    self.imageView.isFilterApplied = YES;
    [self.imageView setNeedsDisplay:YES];
}

@end
