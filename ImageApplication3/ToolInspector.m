//
//  ToolInspector.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "ToolInspector.h"

@interface ToolInspector ()

@end

@implementation ToolInspector

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

- (IBAction)launchSelectedTool:(id)sender {
    id theCell = [sender selectedCell];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedTool" object:theCell];
}
@end
