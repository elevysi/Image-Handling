//
//  SelectionInspector.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "SelectionInspector.h"

@interface SelectionInspector ()

@end

@implementation SelectionInspector

- (id) initWithWindowNibName:(NSString *)windowNibName andRectangle:(NSRect)rect
{
    
    if (self = [super initWithWindowNibName:windowNibName]) {
        selectedRect = rect;
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}
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
    [_xOrigin setFloatValue:selectedRect.origin.x];
    [_yOrigin setFloatValue:selectedRect.origin.y];
    [_selectionWidth setFloatValue:selectedRect.size.width];
    [_selectionHeight setFloatValue:selectedRect.size.height];
}

- (IBAction)setSelectionXOrigin:(id)sender {
    float theXOrigin = [_xOrigin floatValue];
    [notificationCenter postNotificationName:@"RectangleXOrigin" object:[NSNumber numberWithFloat:theXOrigin]];
}

- (IBAction)setSelectionYOrigin:(id)sender {
    float theYOrigin = [_yOrigin floatValue];
    [notificationCenter postNotificationName:@"RectangleYOrigin" object:[NSNumber numberWithFloat:theYOrigin]];
}

- (IBAction)setRectangleWidth:(id)sender {
    float theWidth = [_selectionWidth floatValue];
    [notificationCenter postNotificationName:@"RectangleWidth" object:[NSNumber numberWithFloat:theWidth]];
}

- (IBAction)setRectangleHeight:(id)sender {
    float theHeight = [_selectionHeight floatValue];
    [notificationCenter postNotificationName:@"RectangleHeight" object:[NSNumber numberWithFloat:theHeight]];
}

@end
