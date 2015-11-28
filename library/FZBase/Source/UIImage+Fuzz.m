//
//  UIImage+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "UIImage+Fuzz.h"
#import "UIView+Fuzz.h"
#import <Accelerate/Accelerate.h>
#import <float.h>

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Fuzz)

+ (UIImage*)imageWithColor:(UIColor*)inColor
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    tmpView.backgroundColor = inColor;
    UIImage *returnImage = [[tmpView snapshot] resizableImage];
//	[tmpView autorelease];
    return returnImage;
}


+(UIImage*)imageWithColor:(UIColor *)inColor resizable:(BOOL)resizable sizeRect:(CGRect)sizeRect
{
	if (resizable || CGRectIsEmpty(sizeRect))
	{
		return [[self class] imageWithColor:inColor];
	}
	else
	{
		UIView *tmpView = [[UIView alloc] initWithFrame:sizeRect];
		tmpView.backgroundColor = inColor;
		UIImage *returnImage = [tmpView snapshot];
		return returnImage;
	}
}

-(UIImage*)resizableImage
{
    int top     = (self.size.height / 2.0)-1;
    int left    = (self.size.width  / 2.0)-1;
    
    int bottom  = (self.size.height / 2.0)+1;
    int right   = (self.size.width  / 2.0)+1;
    
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}







-(NSArray*)getPixels
{
    int xx = 0;
    int yy = 0;
    int count = self.size.width *self.size.height;
    
    UIImage *image = self;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (unsigned int)((bytesPerRow * yy) + xx * bytesPerPixel);
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}






// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    //Are these better?
    //UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:self.imageOrientation];
    //UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:self.imageOrientation];
    
    CGImageRelease(imageRef);
    return croppedImage;
}




// Created by Trevor Harmon on 8/5/09, hacked by Fuzz Productions 7/10/12
// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter

- (UIImage *)resizedImage:(CGSize)newSize
{
    return [self resizedImage:newSize interpolationQuality:kCGInterpolationDefault];
}
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
    BOOL transposed;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transposed = YES;
            break;
            
        default:
            transposed = NO;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
            
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
            
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transposed ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

-(UIImage*)resizedImageWithMaxDimension:(CGFloat)max
{
    int newWidth = self.size.width;
    int newHeight = self.size.height;
    
    if(self.size.width > self.size.height)
    {
        if(self.size.width > max)
        {
            double aspectRatio = self.size.height / self.size.width;
            
            newWidth = max;
            newHeight = max * aspectRatio;
        }
    }
    else
    {
        if(self.size.height > max)
        {
            double aspectRatio = self.size.width / self.size.height;
            newWidth = max * aspectRatio;
            newHeight = max;
        }
    }
    return [self resizedImage:CGSizeMake(newWidth,newHeight) interpolationQuality:kCGInterpolationDefault];
    
}



+(void)imageForMovieAtURL:(NSURL*)inURL completion:(void(^)(UIImage *thumb))completion
{
    

    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:inURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
	// [asset release];
    CMTime thumbTime = CMTimeMakeWithSeconds(0,15);
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
    {
        if (result != AVAssetImageGeneratorSucceeded)
        {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        else
        {
            completion([UIImage imageWithCGImage:img]);
        }
		//[generator release];
    };
    
    CGSize maxSize = CGSizeMake(320, 640); // define the size of image.
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
    
    
}



- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount =(int)CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2)
	{
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL])
		{
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else
	{
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL])
		{
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
	
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}




- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1)
	{
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage)
	{
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage)
	{
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
	
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange)
	{
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
		
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
		
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
		
        if (hasBlur)
		{
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1)
			{
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange)
		{
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] =
			{
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
				0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i)
			{
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur)
			{
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else
			{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
		effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
		
        if (effectImageBuffersAreSwapped)
		effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
	
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
	
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
	
    // Draw effect image.
    if (hasBlur)
	{
        CGContextSaveGState(outputContext);
        if (maskImage)
		{
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
	
    // Add in color tint.
    if (tintColor)
	{
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
	
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return outputImage;
}



static  CGContextRef    context = nil;
-(UIImage*)imageByTintingBlack:(UIColor*)newColor andWhite:(UIColor*)bgColor;
{
    
    
    /*
     if(tintedImageCache == nil)
     tintedImageCache = [[NSCache alloc] init];
     */
    
    CGFloat newRed, newGreen, newBlue, newAlpha;
    [newColor getRed:&newRed green:&newGreen blue:&newBlue alpha:&newAlpha];
    
    
    CGFloat bgRed, bgGreen, bgBlue, bgAlpha;
    [bgColor getRed:&bgRed green:&bgGreen blue:&bgBlue alpha:&bgAlpha];
    
    //-----------------------------
    
    UIImage *image = self;
    
    // First get the image into your data buffer
    CGImageRef      imageRef            = [image CGImage];
    NSUInteger      width               = CGImageGetWidth(imageRef);
    NSUInteger      height              = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace          = CGColorSpaceCreateDeviceRGB();
    NSUInteger      bytesPerPixel       = 4;
    NSUInteger      bytesPerRow         = bytesPerPixel * width;
    
    NSUInteger      bitsPerComponent    = 8;
    NSUInteger      totalBytes          = width * height * bytesPerPixel;
    
    unsigned char   *rawData            = (unsigned char*) calloc(totalBytes, sizeof(unsigned char));
    
    
    
    //CGContextRef
    if(context == nil)
        context             = CGBitmapContextCreate(rawData, width, height,
                                                    bitsPerComponent, bytesPerRow, colorSpace,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    
    ///-------------------
    int count = (unsigned int)(width *height);
    int byteIndex = 0;
    
    
    //These coefficients represent the percentage
    //of each chanel in a black and white image
    double RED   = 0.299;
    double GREEN = 0.587;
    double BLUE  = 0.114;
    
    
    for (int i = 0 ; i < count ; i++)
    {
        
        CGFloat red   = (rawData[byteIndex + 0] * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        
        
        
        if(( red   == 1.0)
           &&( green == 1.0)
           &&( blue  == 1.0)
           &&( alpha  == 1.0))
        {
            
            //White
            rawData[byteIndex + 0] = (int)(bgRed    * 255.0 * alpha);
            rawData[byteIndex + 1] = (int)(bgGreen  * 255.0 * alpha);
            rawData[byteIndex + 2] = (int)(bgBlue   * 255.0 * alpha);
            
        }
        else
        {
            
            if(alpha == 1)
            {
                //Pure Black
                if((red == 0) &&(green == 0) &&(blue == 0))
                {
                    rawData[byteIndex + 0] = (int)(newRed    * 255.0);
                    rawData[byteIndex + 1] = (int)(newGreen  * 255.0);
                    rawData[byteIndex + 2] = (int)(newBlue   * 255.0);
                    rawData[byteIndex + 3] = (int)255;
                }
                else
                {
                    //Grays
                    float gray = (RED*red + GREEN*green + BLUE*blue);
                    float white = 1.0-gray;
                    rawData[byteIndex + 0] = 255 * (gray * bgRed    + newRed   * white );
                    rawData[byteIndex + 1] = 255 * (gray * bgGreen  + newGreen * white );
                    rawData[byteIndex + 2] = 255 * (gray * bgBlue   + newBlue  * white );
                    rawData[byteIndex + 3] = (int)255;
                }
            }
            else
            {
                //Black over transparent background
                rawData[byteIndex + 0] = (int)(newRed    * 255.0 *alpha);
                rawData[byteIndex + 1] = (int)(newGreen  * 255.0 *alpha);
                rawData[byteIndex + 2] = (int)(newBlue   * 255.0 *alpha);
            }
        }
        
        
        byteIndex += 4;
    }
    
    ///-------------------
    
    CFDataRef rgbaData = CFDataCreate(NULL, rawData, totalBytes);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(rgbaData);
    CGImageRef rgbImageRef = CGBitmapContextCreateImage(context);
    
    CFRelease(rgbaData);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // use the created CGImage
	UIImage *newImage = [UIImage imageWithCGImage:rgbImageRef];//[[UIImage imageWithCGImage:rgbImageRef] retain];
    
    CGImageRelease(rgbImageRef);
    
    //CGContextRelease(context);
    
    free(rawData);
    
    
    //
	return newImage;//[newImage autorelease];
    
    
}

// http://stackoverflow.com/questions/24239815/how-can-crop-an-image-of-any-size-to-a-certain-dimension
// get sub image
+ (UIImage*) getSubImageFrom:(UIImage*)inImage withRect:(CGRect)inRect{
    
    UIGraphicsBeginImageContext(inRect.size);
    CGContextRef tmpContext = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-inRect.origin.x, -inRect.origin.y, inImage.size.width, inImage.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(tmpContext, CGRectMake(0, 0, inRect.size.width, inRect.size.height));
    
    // draw image
    [inImage drawInRect:drawRect];
    
    // grab image
    UIImage* rtnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rtnImage;
}







@end
