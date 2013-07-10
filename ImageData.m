//
//  ImageData.m
//  ImageApplication3
//
//  Created by Elvis Hatungimana on 5/16/13.
//  Copyright (c) 2013 Elvis Hatungimana. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData



#pragma mark -
#pragma mark Initialization

-(id) initWithNSImage:(NSURL *)url
{
    if (self = [super init]) {
        self.nsImage = [[NSImage alloc] initWithContentsOfURL:url];
        self.bitmapImageRep = [[NSBitmapImageRep alloc] initWithData:[self.nsImage TIFFRepresentation]];
        self.ciImage = [[CIImage alloc] initWithContentsOfURL:url];
        self.imageSize = [self.ciImage extent].size;
        
        self.cgImageRef = [self cGImageRefWithNSImage:self.nsImage];
    }
    return self;
}

- (id) initWithCGImageRef:(CGImageRef) cgImageRef
{
    if (self = [super init]) {
        self.nsImage = [self nsImageWithCGImageRef:cgImageRef];
        self.bitmapImageRep = [[NSBitmapImageRep alloc] initWithData:[self.nsImage TIFFRepresentation]];
        self.ciImage = [self ciImageFromBitmapImageRep:self.bitmapImageRep];
        self.imageSize = [self.ciImage extent].size;
        
        self.cgImageRef = cgImageRef;
    }
    return self;
}

#pragma mark -
#pragma mark Conversion

- (CIImage  *)ciImageFromBitmapImageRep:(NSBitmapImageRep*)imageRep
{
    CIImage *image = [[CIImage alloc] initWithBitmapImageRep:imageRep];
    return image;
}

+(NSImage *) imageFromCIImage:(CIImage *)ciImage
{
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize([ciImage extent].size.width, [ciImage extent].size.height)];
    
    [image addRepresentation:[NSCIImageRep imageRepWithCIImage:ciImage]];
    
    return image;
}

- (NSImage *)nsImageWithCGImageRef:(CGImageRef)cgImage
{
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    return image;
}

- (CGImageRef )cGImageRefWithNSImage:(NSImage *)image
{
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    return maskRef;
}

- (CGImageRef ) cgImageRefFromCIImage:(CIImage *)ciImage
{
    NSImage *image = [ImageData imageFromCIImage:ciImage];
    return [self cGImageRefWithNSImage:image];
}

/*
 Creating a subimage within a larger image, provided with the subimage frame
 */
- (CGImageRef) croppedImageRefFromImageRef:(CGImageRef)imageRef andRect:(CGRect)rect
{
    CGImageRef croppedImage = CGImageCreateWithImageInRect(imageRef, rect);
    return croppedImage;
}

- (NSImage *) nsImageWithCIIImage:(CIImage *)image
{
    CIContext *context = [CIContext contextWithCGContext:
                          [[NSGraphicsContext currentContext] graphicsPort]
                                                 options: nil];
    NSImage *returnImage = [[NSImage alloc] initWithCGImage:[context createCGImage:image fromRect:[image extent]] size:[image extent].size];

    return returnImage;
}




/*
 Creating a mask from the quartz image
 */

- (CGImageRef) drawMaskedClipFrom:(CGImageRef)imageRef andRect:(CGRect)rect
{
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(imageRef),
                                        CGImageGetHeight(imageRef),
                                        CGImageGetBitsPerComponent(imageRef),
                                        CGImageGetBitsPerPixel(imageRef),
                                        CGImageGetBytesPerRow(imageRef),
                                        CGImageGetDataProvider(imageRef),
                                        nil,
                                        FALSE);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * CGImageGetWidth(imageRef);
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGContextClipToMask(context, rect, mask);

    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef maskedImage = CGBitmapContextCreateImage(context);
    
    return maskedImage;
}



#pragma mark -
#pragma mark Pixels Alteration

- (CGImageRef) clearImageRef:(CGImageRef)imageRef
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBFillColor(context, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)1.0 );
    

    CGImageRef resultImage = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return resultImage;
}

- (CGImageRef) offScreenDrawToImage:(CGImageRef)imageRef inRect:(CGRect)rect fromImage:(CGImageRef)sourceImage
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextDrawImage(context, rect, sourceImage);

    CGImageRef resultImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
        
    return resultImage;
}

- (void) copyPixelsFrom:(CGImageRef)sourceImageRef to:(CGImageRef)destinationImageRef
{
    /*
     Source Image
     */
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger width = CGImageGetWidth(sourceImageRef);
    NSUInteger height = CGImageGetHeight(sourceImageRef);
    
    unsigned char *sourceRawData = malloc(height * width * 4);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef sourceContext = CGBitmapContextCreate(sourceRawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(sourceContext, CGRectMake(0, 0, width, height), sourceImageRef);
    CGContextRelease(sourceContext);
    
    /*
     Destination Image
     */
    
        
    NSUInteger destinationWidth = CGImageGetWidth(destinationImageRef);
    NSUInteger destinationHeight = CGImageGetHeight(destinationImageRef);
    
    assert(destinationWidth == width && destinationHeight == height);

    
    unsigned char *destinationRawData = malloc(height * width * 4);
    
    
    CGContextRef destinationContext = CGBitmapContextCreate(destinationRawData,
                                                  width,
                                                  height,
                                                  bitsPerComponent,
                                                  bytesPerRow,
                                                  colorSpace,
    
                                                  kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(destinationContext, CGRectMake(0, 0, width, height), destinationImageRef);
    CGContextRelease(destinationContext);
    
    /*
     Without looping
     */
    destinationRawData = sourceRawData;
    
    
    /*
     With loop, pixel by pixel
     */
    /*
    int byteIndex = 0;
    
    for (int ii = 0 ; ii < (width * height) - 200000 ; ++ii)
    {
        destinationRawData[byteIndex] = sourceRawData[byteIndex];
        destinationRawData[byteIndex+1] = sourceRawData[byteIndex+1];
        destinationRawData[byteIndex+2] = sourceRawData[byteIndex+2];
        destinationRawData[byteIndex+3] = sourceRawData[byteIndex+3];
        
        byteIndex += 4;
    }
     */
    
    CGContextRef ctx = CGBitmapContextCreate(destinationRawData,
                                             width,
                                             height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedLast);
    
    CGImageRef resultImage = CGBitmapContextCreateImage(ctx);
    
    CGImageRelease(resultImage);
    free(sourceRawData);
    free(destinationRawData);
    
}

#pragma mark -
#pragma mark Filters

- (void) setExposureValue:(NSNumber *)exposureValue
{
    if (self.exposureFilter == nil)
    {
        self.exposureFilter = [CIFilter filterWithName: @"CIExposureAdjust"];
        [self.exposureFilter setDefaults];
    }
    
    [self.exposureFilter setValue:exposureValue forKey: @"inputEV"];    
}

- (void) setSaturationValue:(NSNumber *)saturationValue
{
    if (self.saturationFilter == nil)
    {
        self.saturationFilter = [CIFilter filterWithName:@"CIColorControls"];
        [self.saturationFilter setDefaults]; //CICOntrols also takes care of contrast and brightness, setting these to default
    }
    [self.saturationFilter setValue:saturationValue forKey: @"inputSaturation"];
}

- (void) setHueValue:(NSNumber *)hueValue
{
    if (self.hueFilter == nil)
        self.hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    
    [self.hueFilter setValue:hueValue forKey: @"inputAngle"];
}

-(CIImage *)imageWithFilter:(CIImage *)ciimg inView:(NSView *)view
{
    if (self.exposureFilter)
    {
        [self.exposureFilter setValue:ciimg forKey:@"inputImage"];
        ciimg = [self.exposureFilter valueForKey: @"outputImage"];
    }
    
    if (self.saturationFilter)
    {
        [self.saturationFilter setValue:ciimg forKey:@"inputImage"];
        ciimg = [self.saturationFilter valueForKey: @"outputImage"];
    }
    
    if (self.hueFilter)
    {
        [self.hueFilter setValue:ciimg forKey:@"inputImage"];
        ciimg = [self.hueFilter valueForKey: @"outputImage"];
    }
    self.filteredImage = ciimg;
    return ciimg;
}


#pragma mark -
#pragma mark Scaling


- (CGRect) scaledRectFromImageRect:(CGRect)rect fromView:(NSView *)_view;
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.scalefactor, self.scalefactor);
    rect = CGRectApplyAffineTransform(rect, scaleTransform);
    NSSize finalSize = NSMakeSize ( rect.size.width, rect.size.height );
    NSRect finalRect;
    finalRect.size = finalSize;
    
    return finalRect;
}

- (CGAffineTransform ) applyScaleCGAffineTranslationTransform
{
    return CGAffineTransformMakeTranslation(self.scalefactor, self.scalefactor);
}


/*
 Returns the image canvas into the view, where the image shall be drawn
 */
- (void) setScalefactorForImage:(CIImage *)image FromViewFrame:(NSRect)targetRect
{
    // if the sizes are the same, we're already done.
    if ( NSEqualSizes([image extent].size, targetRect.size) )
    {
//        return targetRect;
        [self setScaleFactor:1.0f];
        return;
    }
    
    
    NSSize theImageSize = [image extent].size;
    CGFloat soureWidth = theImageSize.width;
    CGFloat sourceHeight = theImageSize.height;
    
    
    // figure out the difference in size for each side, and use
    // the larger adjustment for both edges (maintains aspect ratio).
    
    
    CGFloat widthAdjust = targetRect.size.width / soureWidth;
    CGFloat heightAdjust = targetRect.size.height / sourceHeight;
    CGFloat theScaleFactor = 1.0;
    
    
    if ( widthAdjust < heightAdjust )
        theScaleFactor = widthAdjust;
    else
        theScaleFactor = heightAdjust;
    
    
    [self setScalefactor:theScaleFactor];

}

- (CGRect) getDestinationRectForImage:(CIImage *)image FromView:(NSView*)view
{
    /*
     Create the destination Rect for The image in View
     */
    CGRect rect = [view bounds];
    rect.size.width = [image extent].size.width;
    rect.size.height = [image extent].size.height;
    CGRect finalRect = [self scaledRectFromImageRect:rect fromView:view];
    
    return finalRect;
}

- (void) setScaleFactor:(CGFloat)scaleFactorValue
{
    self.scalefactor = scaleFactorValue;
}

- (void) dealloc
{
    CGImageRelease(self.cgImageRef);
}

@end
