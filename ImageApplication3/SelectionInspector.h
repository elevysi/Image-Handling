//
//  SelectionInspector.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SelectionInspector : NSWindowController
{
    NSTextField *_xOrigin;
    NSTextField *_yOrigin;
    NSTextField *_selectionWidth;
    NSTextField *_selectionHeight;
    NSRect selectedRect;
    NSNotificationCenter *notificationCenter;
}

@property (strong) IBOutlet NSTextField *xOrigin;
@property (strong) IBOutlet NSTextField *yOrigin;
@property (strong) IBOutlet NSTextField *selectionWidth;
@property (strong) IBOutlet NSTextField *selectionHeight;


- (id) initWithWindowNibName:(NSString *)windowNibName andRectangle:(NSRect)rect;


- (IBAction)setSelectionXOrigin:(id)sender;
- (IBAction)setSelectionYOrigin:(id)sender;
- (IBAction)setRectangleWidth:(id)sender;
- (IBAction)setRectangleHeight:(id)sender;

@end
