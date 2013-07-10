//
//  ImageController.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "ImageController.h"

@implementation ImageController



#pragma mark -
#pragma mark Initialization


- (id) init{
    if (self = [super init]) {
        /*
          Selected Rectangle Notifications
         */
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
                                   name:@"ExposureValue"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getSaturationValue:)
                                   name:@"SaturationValue"
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(getHueValue:)
                                   name:@"HueValue"
                                 object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (IBAction)Composite:(id)sender {
//    croppedController.imageData.cgImageRef;
}

- (IBAction)saveCropped:(id)sender
{
    
    CIImage *image = croppedController.imageData.filteredImage;
    NSImage *nsImg = [ImageData imageFromCIImage:image];
    
    CGImageRef imageRef = [self.imageData cGImageRefWithNSImage:nsImg];
    
    
    CGImageRef clearedCropInImage = [self.imageData offScreenDrawToImage:self.imageData.cgImageRef inRect:[self.imageView rectangleToCrop] fromImage:imageRef];
    
    self.imageData.cgImageRef = clearedCropInImage;

    [self.imageView setNeedsDisplay:YES];
        
    NSLog(@"Saving Crop");
    

}

- (IBAction)openDocument:(id)sender
{
    NSRect viewFrame = [self.window.contentView bounds];
    
    /*
     Initialize the image View
     */
    self.imageView = [[ImageView alloc] initWithFrame:viewFrame];
    
    NSInteger resizingMask = ( NSViewWidthSizable | NSViewHeightSizable );
    
    [self.imageView setAutoresizingMask:resizingMask];
    [self.window.contentView addSubview:self.imageView];
    
    
    __block NSOpenPanel         *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSImage imageFileTypes]];
    
    [panel beginSheetModalForWindow:[self.imageView window] completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            /*
             Initialize the image Data
             */
            self.imageData = [[ImageData alloc] initWithNSImage:[panel URL]];
            
            /*
             Give the image data to the View
             */
            self.imageView.imageData = self.imageData;
            
            [self.imageView setNeedsDisplay:YES];
        }
        panel = nil; //prevent strong ref cycle
    }];
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
    if (theTag == 1)
    {
        self.imageView.currentToolMode = cropToolMode;
        CGRect rectangleToCrop = [self.imageView rectangleToCrop];
        
        CGImageRef image = [self.imageData croppedImageRefFromImageRef:self.imageData.cgImageRef andRect:rectangleToCrop];
        
        /*
         Display the new Image in new Window
         */
        
        croppedController = [[CroppedWindowController alloc] initWithWindowNibName:@"CroppedWindowController" andCGImageRef:image];
        [croppedController showWindow:self];
        [croppedController showPropertiesInspector:croppedController];

        
        /*
         Mask The portion from Original Window and draw To View
         */
        self.imageView.isCropped = YES;
        
        
//        CGImageRef clearedImage = [self.imageData clearImageRef:image];
        
//        CGImageRef clearedCropInImage = [self.imageData offScreenDrawToImage:self.imageData.cgImageRef inRect:[self.imageView rectangleToCrop] fromImage:clearedImage];
        
//        self.imageData.cgImageRef = clearedCropInImage;

        

        [self.imageView setNeedsDisplay:YES];
        
//        CGImageRelease(clearedImage);
        CGImageRelease(image);
    }
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
