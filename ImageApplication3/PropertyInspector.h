//
//  PropertyInspector.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PropertyInspector : NSWindowController
{
    NSNotificationCenter                *notificationCenter;
    NSSliderCell *_exposureSlider;
    NSSliderCell *_saturationSlider;
    NSSliderCell *_hueSlider;
}
- (IBAction)postPropertiesValues:(id)sender;

@property (strong) IBOutlet NSSliderCell *exposureSlider;
@property (strong) IBOutlet NSSliderCell *saturationSlider;
@property (strong) IBOutlet NSSliderCell *hueSlider;
@end
