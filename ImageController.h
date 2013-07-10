//
//  ImageController.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageView.h"
#import "ImageData.h"
#import "SelectionInspector.h"
#import "PropertyInspector.h"
#import "ToolInspector.h"
#import "CroppedWindowController.h"

@interface ImageController : NSObject <NSApplicationDelegate>
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

@property (assign) IBOutlet NSWindow *window;
//@property () NSWindow             *window;
@property (strong) ImageView*           imageView;
@property (strong) ImageData*           imageData;


- (IBAction)openDocument:(id)sender;
- (IBAction)showToolsInspector:(id)sender;
- (IBAction)showSelectionInspector:(id)sender;
- (IBAction)showPropertiesInspector:(id)sender;


- (IBAction)Composite:(id)sender;
- (IBAction)saveCropped:(id)sender;

@end
