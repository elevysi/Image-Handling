//
//  CroppedWindowController.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/20/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageView.h"
#import "ImageData.h"
#import "SelectionInspector.h"
#import "PropertyInspector.h"
#import "ToolInspector.h"

@interface CroppedWindowController : NSWindowController
{
    ImageView                       *_imageView;
    ImageData                       *_imageData;
    
    NSNotificationCenter            *notificationCenter;
    
    ToolInspector                   *tools;
    SelectionInspector              *selectionInspector;
    PropertyInspector               *propertiesController;
    //    IBOutlet NSWindow               *_window;
}

//@property (assign) IBOutlet NSWindow *window;
//@property () NSWindow             *window;
@property (strong) ImageView*           imageView;
@property (strong) ImageData*           imageData;

- (id) initWithWindowNibName:(NSString *)windowNibName andCGImageRef:(CGImageRef)imageRef;

- (IBAction)showToolsInspector:(id)sender;
- (IBAction)showSelectionInspector:(id)sender;
- (IBAction)showPropertiesInspector:(id)sender;


@end