//
//  ImageData.h
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface ImageData : NSObject
{
    NSImage                 *_nsImage;
    CIImage                 *_ciImage;
    NSBitmapImageRep        *_bitmapImageRep;
    CGImageRef              _cgImageRef;
    NSSize                  _imageSize;

    CGFloat                 _scaleFactor;
    
    
    CIFilter                *_exposureFilter;
    CIFilter                *_saturationFilter;
    CIFilter                *_hueFilter;
    
    
    CIImage                 *_filteredImage;
}
@property (strong) NSImage*                 nsImage;
@property (strong) CIImage*                 ciImage;
@property (strong) NSBitmapImageRep*        bitmapImageRep;
@property () CGImageRef                     cgImageRef;
//@property (nonatomic, retain) CGImageRef cgImageRef __attribute__((NSObject));
@property () NSSize                         imageSize;


@property () CGFloat                        scalefactor;
@property (strong)CIFilter                  *exposureFilter;
@property (strong)CIFilter                  *saturationFilter;
@property (strong)CIFilter                  *hueFilter;
@property (strong)CIImage                   *filteredImage;


- (id) initWithNSImage:(NSURL *)url;
- (id) initWithCGImageRef:(CGImageRef) cgImageRef;


- (NSImage *)nsImageWithCGImageRef:(CGImageRef )cgImage;
- (CGImageRef )cGImageRefWithNSImage:(NSImage *)image;
- (CIImage  *)ciImageFromBitmapImageRep:(NSBitmapImageRep*)imageRep;


- (CGImageRef) croppedImageRefFromImageRef:(CGImageRef)imageRef andRect:(CGRect)rect;

- (CGImageRef) drawMaskedClipFrom:(CGImageRef)imageRef andRect:(CGRect)rect;


- (void) setExposureValue:(NSNumber *)exposureValue;
- (void) setSaturationValue:(NSNumber *)saturationValue;
- (void) setHueValue:(NSNumber *)hueValue;
- (CIImage *)imageWithFilter:(CIImage *)ciimg inView:(NSView *)view;

- (CGRect) getDestinationRectForImage:(CIImage *)image FromView:(NSView*)view;
- (CGAffineTransform ) applyScaleCGAffineTranslationTransform;
- (CGRect) scaledRectFromImageRect:(CGRect)rect fromView:(NSView *)_view;
- (void) setScalefactorForImage:(CIImage *)image FromViewFrame:(NSRect)targetRect;

- (CGImageRef) clearImageRef:(CGImageRef)imageRef;
- (CGImageRef) offScreenDrawToImage:(CGImageRef)imageRef inRect:(CGRect)rect fromImage:(CGImageRef)sourceImage;

+(NSImage *) imageFromCIImage:(CIImage *)ciImage;



@end
