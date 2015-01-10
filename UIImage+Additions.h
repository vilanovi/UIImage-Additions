//
//  UIImage+Additions.h
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//
// Copyright (c) 2013 Joan Martin, vilanovi@gmail.com.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import <UIKit/UIKit.h>

typedef struct __ADDCornerInset
{
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} ADDCornerInset;

UIKIT_EXTERN const ADDCornerInset ADDCornerInsetZero;

UIKIT_STATIC_INLINE ADDCornerInset ADDCornerInsetMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight)
{
    ADDCornerInset cornerInset = {topLeft, topRight, bottomLeft, bottomRight};
    return cornerInset;
}

UIKIT_STATIC_INLINE ADDCornerInset ADDCornerInsetMakeWithRadius(CGFloat radius)
{
    ADDCornerInset cornerInset = {radius, radius, radius, radius};
    return cornerInset;
}

UIKIT_STATIC_INLINE BOOL ADDCornerInsetEqualToCornerInset(ADDCornerInset cornerInset1, ADDCornerInset cornerInset2)
{
    return
    cornerInset1.topLeft == cornerInset2.topLeft &&
    cornerInset1.topRight == cornerInset2.topRight &&
    cornerInset1.bottomLeft == cornerInset2.bottomLeft &&
    cornerInset1.bottomRight == cornerInset2.bottomRight;
}

FOUNDATION_EXTERN NSString* NSStringFromADDCornerInset(ADDCornerInset cornerInset);

/**
 * The image tinting styles.
 **/
typedef enum __ADDImageTintStyle
{
    /**
     * Keep transaprent pixels (alpha == 0) and tint all other pixels.
     **/
    ADDImageTintStyleKeepingAlpha      = 1,
    
    /**
     * Keep non transparent pixels and tint only those that are translucid.
     **/
    ADDImageTintStyleOverAlpha         = 2,
    
    /**
     * Remove (turn to transparent) non transparent pixels and tint only those that are translucid.
     **/
    ADDImageTintStyleOverAlphaExtreme  = 3,
} ADDImageTintStyle;

/**
 * Defines the gradient direction.
 **/
typedef enum __ADDImageGradientDirection
{
    /**
     * Vertical direction.
     **/
    ADDImageGradientDirectionVertical    = 1,
    
    /**
     * Horizontal direction.
     **/
    ADDImageGradientDirectionHorizontal  = 2,
    
    /**
     * Left slanted direction.
     **/
    ADDImageGradientDirectionLeftSlanted = 3,
    
    /**
     * Right slanted direction.
     **/
    ADDImageGradientDirectionRightSlanted = 4
} ADDImageGradientDirection;

/**
 * This category add methods to `UIImage` to create and modify in runtime images.
 * 
 * All static methods that return images, have a caching system so consecutive calls to get the same image return the same image instance (speeding up the process).
 **/
@interface UIImage (Additions)

/** *************************************************** **
* @name Create images from colors
** *************************************************** **/

/**
 * Creates an image of 1x1 points of the given color.
 * @param color The color.
 * @return An image instance for the given color.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)add_imageWithColor:(UIColor*)color;

/**
 * Creates an image of the given size and the given color.
 * @param color The color.
 * @param size The size.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size;

/**
 * Creates an image of the given size and the given color with a corner radius.
 * @param color The color.
 * @param size The size.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 * Creates an image of the given size and the given color with a corner inset.
 * @param color The color.
 * @param size The size.
 * @param cornerInset The corner inset.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(ADDCornerInset)cornerInset;

/** *************************************************** **
 * @name Create rezisable images from colors
 ** *************************************************** **/

/**
 * Creates a resizable image of the given color.
 * @param color The color.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)add_resizableImageWithColor:(UIColor*)color;

/**
 * Creates a resizable image of the given color with a corner radius.
 * @param color The color.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)add_resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius;

/**
 * Creates a resizable image of the given color with a corner inset.
 * @param color The color.
 * @param cornerInset The corner inset.
 * @return A new image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)add_resizableImageWithColor:(UIColor*)color cornerInset:(ADDCornerInset)cornerInset;

/**
 * Returns a black resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_blackColorImage;

/**
 * Returns a dark gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_darkGrayColorImage;

/**
 * Returns a light gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_lightGrayColorImage;

/**
 * Returns a white resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_whiteColorImage;

/**
 * Returns a gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_grayColorImage;

/**
 * Returns a red resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_redColorImage;

/**
 * Returns a green resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_greenColorImage;

/**
 * Returns a blue resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_blueColorImage;

/**
 * Returns a cyan resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_cyanColorImage;

/**
 * Returns a yellow resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_yellowColorImage;

/**
 * Returns a magenta resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_magentaColorImage;

/**
 * Returns a orange resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_orangeColorImage;

/**
 * Returns a purple resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_purpleColorImage;

/**
 * Returns a brown resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_brownColorImage;

/**
 * Returns a transparent (clear color) resizable image.
 * @return An image instance.
 **/
+ (UIImage*)add_clearColorImage;

/** *************************************************** **
 * @name Tinting Images
 ** *************************************************** **/

/**
 * Returns the image object associated with the specified filename and tints it.
 * @param name The name of the image.
 * @param color The color to tint the image.
 * @param tintStyle The tint style.
 * @return An image instance.
 * @discussion Images are cached in dynamic memory.
 **/
+ (UIImage*)add_imageNamed:(NSString *)name tintColor:(UIColor*)color style:(ADDImageTintStyle)tintStyle;

/**
 * Creates an image object associated with the specified filename and tints it.
 * @param name The name of the image.
 * @param color The color to tint the image.
 * @param tintStyle The tint style.
 * @return An image instance.
 **/
- (UIImage*)add_tintedImageWithColor:(UIColor*)color style:(ADDImageTintStyle)tintStyle;

/** *************************************************** **
 * @name Rounding corners
 ** *************************************************** **/

/**
 * Creates and returns a round (or oval) image.
 * @return An image instance.
 * @discussion The image created has the maximum possible corner radius (so if it is squared, it returns a cirled image).
 **/
- (UIImage*)add_imageWithRoundedBounds;

/**
 * Creates and returns an image with a corner radius.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method may return nil if the corner radius is not valid (too big) for the given image.
 **/
- (UIImage*)add_imageWithCornerRadius:(CGFloat)cornerRadius;

/**
 * Creates and returns an image with a corner inset.
 * @param cornerInset The corner inset.
 * @return An image instance.
 * @discussion This method may return nil if the corner inset is not valid for the given image.
 **/
- (UIImage*)add_imageWithCornerInset:(ADDCornerInset)cornerInset;

/**
 * Returns YES is the corner inset is valid for the current image. Otherwise returns NO.
 * @return A boolean indicating if the corner inset is valid for the current image.
 **/
- (BOOL)add_isValidCornerInset:(ADDCornerInset)cornerInset;

/** *************************************************** **
 * @name Drawing image on image
 ** *************************************************** **/

/**
 * Creates and returns a new image adding to the current image in the center the new image.
 * @param image The image to add.
 * @discussion The image being added is centered in the middle of the current image and the returned image has the same size as the current image.
 **/
- (UIImage*)add_imageAddingImage:(UIImage*)image;

/**
 * Creates and returns a new image adding to the current image.
 * @param image The image to add.
 * @param offset The offset from the top-left corner that indicates where to add the image.
 * @discussion The returned image has the same size as the current image.
 **/
- (UIImage*)add_imageAddingImage:(UIImage*)image offset:(CGPoint)offset;

/** *************************************************** **
 * @name Gradient image generation
 ** *************************************************** **/

/**
 * Generates an gradient image from the given colors.
 * @param colors An array of colors. This array must contain at least one color.
 * @param size The size of the returned image.
 * @param dicrection The gradient direction.
 * @return An image instance.
 **/
+ (UIImage*)add_imageWithGradient:(NSArray*)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction;

/**
 * Generates an gradient resizable image from the given colors.
 * @param colors An array of colors. This array must contain at least one color.
 * @param size The minimal size of the returned resizable image.
 * @param dicrection The gradient direction.
 * @return An image instance.
 **/
+ (UIImage*)add_resizableImageWithGradient:(NSArray*)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction;

@end

#pragma mark - Categories

/**
 * Adding `ADDCornerInset` support to `NSValue`.
 **/
@interface NSValue (NSValueADDCornerInsetExtensions)

/**
 * Creates a `NSValue` from a `ADDCornerInset`.
 * @param cornerInset The corner inset.
 * @return A `NSValue` representation of the corner inset.
 **/
+ (NSValue*)valueWithADDCornerInset:(ADDCornerInset)cornerInset;

/**
 * Retreives the `ADDCornerInset` value.
 * @return A the corner inset value.
 **/
- (ADDCornerInset)ADDCornerInsetValue;

@end
