//
//  UIImage+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Fuzz)
/**
 *  A convenience method for generating an image from a UIColor to be used 
 *  in places where an UIImageView is required
 *
 *  @param inColor The desired image color
 *
 *  @return The generated image
 */
+(UIImage*)imageWithColor:(UIColor*)inColor;

/**
 * An extension of the imageWithColor convenience method which allows you to
 * specify whether or not the image returned will be resizable. 
 * If resizable is NO, you must provide a sizeRect or the method will default to
 * returning a resizable image.
 *
 * @param inColor The desired image color
 * @param resizable Specify NO to receive an image with an explicit size.
 * @param sizeRect The rectangle declaring the size of the image
 *
 * @return The generated image
 */
+(UIImage*)imageWithColor:(UIColor *)inColor resizable:(BOOL)resizable sizeRect:(CGRect)sizeRect;

/**
 *  A method for generating thumbnails of movies not yet downloaded or streamed by the user
 *
 *  @param inURL      the location of the movie
 *  @param completion The completion block containing the generated image.
 */

+(void)imageForMovieAtURL:(NSURL*)inURL completion:(void(^)(UIImage *thumb))completion;


/**
 *  A convenience method to generate a resizable image with cap insets around the center pixel
 *
 *  @param inName the image being stretched
 *
 *  @return the resizeable image
 */
-(UIImage*)resizableImage;

/**
 *  Returns an image that takes up frame of the passed rect of a large view. You will need to do some math
 *  beforehand (content offset * 1/zoomscale) to get the appropriate origin.
 *
 *  @param inImage Image to be cropped
 *  @param inRect  Rect part of image to be cropped
 *
 *  @return Image after cropping
 */
+ (UIImage*)getSubImageFrom:(UIImage*)inImage withRect:(CGRect)inRect;


/**
 *  Returns a rescaled copy of the image, taking into account its orientation. The image will be scaled disproportionately if necessary to fit the bounds
 *  specified by the parameter
 *
 *  @param newSize the new image size
 *  @param quality the new image size
 *  @return the created image
 */
- (UIImage*)resizedImage:(CGSize)newSize;
- (UIImage*)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)resizedImageWithMaxDimension:(CGFloat)max;


/**
 *  A method for getting the pixel data of an image. The returned array contains instances of UIColor, one for each pixel. 
 *  This is not an efficient method of image manipulation. It exists entirely for convenience.
 *
 *  @return An array of UIColor instances
 */
-(NSArray*)getPixels;



/**
 *  Creates a new UIImage from the original with the new bounds. The bounds will be adjusted using CGRectIntegral. 
 *  This method ignores the image's imageOrientation setting.
 *  @param bounds The area of the new image
 *
 *  @return The image created by cropping
 */
- (UIImage*)croppedImage:(CGRect)bounds;




- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;



@end
