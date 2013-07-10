//
//  PropertyInspector.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "PropertyInspector.h"
#import <Quartz/Quartz.h>

@interface PropertyInspector ()

@end

@implementation PropertyInspector

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        notificationCenter = [NSNotificationCenter defaultCenter];
        
        /*
         Set up the sliders
         */
//        [self setupExposure];
//        [self setupSaturation];
//        [self setupHue];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)postPropertiesValues:(id)sender {
    id changedSlider = [sender selectedCell];
    NSInteger setValue = [[sender selectedCell] tag];
    if (setValue == 0)
        [notificationCenter postNotificationName:@"ExposureValue2" object:[NSNumber numberWithFloat:[changedSlider floatValue]]];
    if (setValue == 1)
        [notificationCenter postNotificationName:@"SaturationValue2" object:[NSNumber numberWithFloat:[changedSlider floatValue]]];
    if (setValue == 2)
        [notificationCenter postNotificationName:@"HueValue2" object:[NSNumber numberWithFloat:[changedSlider floatValue]]];
}

- (void) setupExposure
{
    CIFilter*      filter = [CIFilter filterWithName: @"CIExposureAdjust"];
    NSDictionary*  input = [[filter attributes] objectForKey: @"inputEV"];
    
    NSLog(@"Exxposure min = %f, default = %f, max = %f", [[input objectForKey: @"CIAttributeSliderMin"] floatValue], [[input objectForKey:@"CIAttributeDefault"] floatValue], [[input objectForKey: @"CIAttributeSliderMax"] floatValue]);
    
    
//    [self.exposureSlider setMinValue: [[input objectForKey: @"CIAttributeSliderMin"] floatValue]/4.0];
//    [self.exposureSlider setMaxValue: [[input objectForKey: @"CIAttributeSliderMax"] floatValue]/4.0];
//    [self.hueSlider setFloatValue:[[input objectForKey:@"CIAttributeDefault"] floatValue]];
}

- (void) setupSaturation
{
    CIFilter*      filter = [CIFilter filterWithName: @"CIColorControls"];
    NSDictionary*  input = [[filter attributes] objectForKey: @"inputSaturation"];
    
    NSLog(@"Saturation min = %f, default = %f, max = %f", [[input objectForKey: @"CIAttributeSliderMin"] floatValue], [[input objectForKey:@"CIAttributeDefault"] floatValue], [[input objectForKey: @"CIAttributeSliderMax"] floatValue]);
    
//    [self.saturationSlider setMinValue: [[input objectForKey: @"CIAttributeSliderMin"] floatValue]];
//    [self.saturationSlider setMaxValue: [[input objectForKey: @"CIAttributeSliderMax"] floatValue]];
//    [self.hueSlider setFloatValue:[[input objectForKey:@"CIAttributeDefault"] floatValue]];
}

- (void) setupHue
{
    CIFilter*      filter = [CIFilter filterWithName: @"CIHueAdjust"];
    NSDictionary*  input = [[filter attributes] objectForKey: @"inputAngle"];
    
    NSLog(@"Hue min = %f, default = %f, max = %f", [[input objectForKey: @"CIAttributeSliderMin"] floatValue], [[input objectForKey:@"CIAttributeDefault"] floatValue], [[input objectForKey: @"CIAttributeSliderMax"] floatValue]);
    
//    [self.hueSlider setMinValue: [[input objectForKey: @"CIAttributeSliderMin"] floatValue]];
//    [self.hueSlider setMaxValue: [[input objectForKey: @"CIAttributeSliderMax"] floatValue]];
//    [self.hueSlider setFloatValue:[[input objectForKey:@"CIAttributeDefault"] floatValue]];
}
@end
