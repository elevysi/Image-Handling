//
//  CroppedWindowController.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/20/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ImageView.h"
#import "ImageData.h"
#import "SelectionInspector.h"
#import "PropertyInspector.h"
#import "ToolInspector.h"
#import "CroppedWindowController.h"

@interface CroppedWindowController : NSWindowController
{
    ImageView                       *_imageView;
    ImageData                       *_imageData;
    
    NSNotificationCenter            *notificationCenter;
    
    ToolInspector                   *tools;
    SelectionInspector              *selectionInspector;
    PropertyInspector               *propertiesController;
    CroppedWindowController         *croppedController;
    //    IBOutlet NSWindow               *_window;
}

//@property (assign) IBOutlet NSWindow *window;
//@property () NSWindow             *window;
@property (strong) ImageView*           imageView;
@property (strong) ImageData*           imageData;

- (IBAction)showToolsInspector:(id)sender;
- (IBAction)showSelectionInspector:(id)sender;
- (IBAction)showPropertiesInspector:(id)sender;

- (id) initWithWindowNibName:(NSString *)windowNibName andCGImageRef:(CGImageRef)imageRef;

@end