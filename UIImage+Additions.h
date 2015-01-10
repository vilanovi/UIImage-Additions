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

typedef struct __UICornerInset
{
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} UICornerInset;

UIKIT_EXTERN const UICornerInset UICornerInsetZero;

UIKIT_STATIC_INLINE UICornerInset UICornerInsetMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight)
{
    UICornerInset cornerInset = {topLeft, topRight, bottomLeft, bottomRight};
    return cornerInset;
}

UIKIT_STATIC_INLINE UICornerInset UICornerInsetMakeWithRadius(CGFloat radius)
{
    UICornerInset cornerInset = {radius, radius, radius, radius};
    return cornerInset;
}

UIKIT_STATIC_INLINE BOOL UICornerInsetEqualToCornerInset(UICornerInset cornerInset1, UICornerInset cornerInset2)
{
    return
    cornerInset1.topLeft == cornerInset2.topLeft &&
    cornerInset1.topRight == cornerInset2.topRight &&
    cornerInset1.bottomLeft == cornerInset2.bottomLeft &&
    cornerInset1.bottomRight == cornerInset2.bottomRight;
}

FOUNDATION_EXTERN NSString* NSStringFromUICornerInset(UICornerInset cornerInset);

/**
 * The image tinting styles.
 **/
typedef enum __UIImageTintedStyle
{
    /**
     * Keep transaprent pixels (alpha == 0) and tint all other pixels.
     **/
    UIImageTintedStyleKeepingAlpha      = 1,
    
    /**
     * Keep non transparent pixels and tint only those that are translucid.
     **/
    UIImageTintedStyleOverAlpha         = 2,
    
    /**
     * Remove (turn to transparent) non transparent pixels and tint only those that are translucid.
     **/
    UIImageTintedStyleOverAlphaExtreme  = 3,
} UIImageTintedStyle;

/**
 * Defines the gradient direction.
 **/
typedef enum __UIImageGradientDirection
{
    /**
     * Vertical direction.
     **/
    UIImageGradientDirectionVertical    = 1,
    
    /**
     * Horizontal direction.
     **/
    UIImageGradientDirectionHorizontal  = 2,
    
    /**
     * Left slanted direction.
     **/
    UIImageGradientDirectionLeftSlanted = 3,
    
    /**
     * Right slanted direction.
     **/
    UIImageGradientDirectionRightSlanted = 4
} UIImageGradientDirection;

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
+ (UIImage*)imageWithColor:(UIColor*)color;

/**
 * Creates an image of the given size and the given color.
 * @param color The color.
 * @param size The size.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

/**
 * Creates an image of the given size and the given color with a corner radius.
 * @param color The color.
 * @param size The size.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 * Creates an image of the given size and the given color with a corner inset.
 * @param color The color.
 * @param size The size.
 * @param cornerInset The corner inset.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image.
 **/
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset;

/** *************************************************** **
 * @name Create rezisable images from colors
 ** *************************************************** **/

/**
 * Creates a resizable image of the given color.
 * @param color The color.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)resizableImageWithColor:(UIColor*)color;

/**
 * Creates a resizable image of the given color with a corner radius.
 * @param color The color.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius;

/**
 * Creates a resizable image of the given color with a corner inset.
 * @param color The color.
 * @param cornerInset The corner inset.
 * @return A new image instance.
 * @discussion This method uses the screen density of the device to generate an appropiate pixel density image. Also, the generated image is as small as possible.
 **/
+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerInset:(UICornerInset)cornerInset;

/**
 * Returns a black resizable image.
 * @return An image instance.
 **/
+ (UIImage*)blackColorImage;

/**
 * Returns a dark gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)darkGrayColorImage;

/**
 * Returns a light gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)lightGrayColorImage;

/**
 * Returns a white resizable image.
 * @return An image instance.
 **/
+ (UIImage*)whiteColorImage;

/**
 * Returns a gray resizable image.
 * @return An image instance.
 **/
+ (UIImage*)grayColorImage;

/**
 * Returns a red resizable image.
 * @return An image instance.
 **/
+ (UIImage*)redColorImage;

/**
 * Returns a green resizable image.
 * @return An image instance.
 **/
+ (UIImage*)greenColorImage;

/**
 * Returns a blue resizable image.
 * @return An image instance.
 **/
+ (UIImage*)blueColorImage;

/**
 * Returns a cyan resizable image.
 * @return An image instance.
 **/
+ (UIImage*)cyanColorImage;

/**
 * Returns a yellow resizable image.
 * @return An image instance.
 **/
+ (UIImage*)yellowColorImage;

/**
 * Returns a magenta resizable image.
 * @return An image instance.
 **/
+ (UIImage*)magentaColorImage;

/**
 * Returns a orange resizable image.
 * @return An image instance.
 **/
+ (UIImage*)orangeColorImage;

/**
 * Returns a purple resizable image.
 * @return An image instance.
 **/
+ (UIImage*)purpleColorImage;

/**
 * Returns a brown resizable image.
 * @return An image instance.
 **/
+ (UIImage*)brownColorImage;

/**
 * Returns a transparent (clear color) resizable image.
 * @return An image instance.
 **/
+ (UIImage*)clearColorImage;

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
+ (UIImage*)imageNamed:(NSString *)name tintColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle;

/**
 * Creates an image object associated with the specified filename and tints it.
 * @param name The name of the image.
 * @param color The color to tint the image.
 * @param tintStyle The tint style.
 * @return An image instance.
 **/
- (UIImage*)tintedImageWithColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle;

/** *************************************************** **
 * @name Rounding corners
 ** *************************************************** **/

/**
 * Creates and returns a round (or oval) image.
 * @return An image instance.
 * @discussion The image created has the maximum possible corner radius (so if it is squared, it returns a cirled image).
 **/
- (UIImage*)imageWithRoundedBounds;

/**
 * Creates and returns an image with a corner radius.
 * @param cornerRadius The corner radius.
 * @return An image instance.
 * @discussion This method may return nil if the corner radius is not valid (too big) for the given image.
 **/
- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius;

/**
 * Creates and returns an image with a corner inset.
 * @param cornerInset The corner inset.
 * @return An image instance.
 * @discussion This method may return nil if the corner inset is not valid for the given image.
 **/
- (UIImage*)imageWithCornerInset:(UICornerInset)cornerInset;

/**
 * Returns YES is the corner inset is valid for the current image. Otherwise returns NO.
 * @return A boolean indicating if the corner inset is valid for the current image.
 **/
- (BOOL)isValidCornerInset:(UICornerInset)cornerInset;

/** *************************************************** **
 * @name Drawing image on image
 ** *************************************************** **/

/**
 * Creates and returns a new image adding to the current image in the center the new image.
 * @param image The image to add.
 * @discussion The image being added is centered in the middle of the current image and the returned image has the same size as the current image.
 **/
- (UIImage*)imageAddingImage:(UIImage*)image;

/**
 * Creates and returns a new image adding to the current image.
 * @param image The image to add.
 * @param offset The offset from the top-left corner that indicates where to add the image.
 * @discussion The returned image has the same size as the current image.
 **/
- (UIImage*)imageAddingImage:(UIImage*)image offset:(CGPoint)offset;

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
+ (UIImage*)imageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction;

/**
 * Generates an gradient resizable image from the given colors.
 * @param colors An array of colors. This array must contain at least one color.
 * @param size The minimal size of the returned resizable image.
 * @param dicrection The gradient direction.
 * @return An image instance.
 **/
+ (UIImage*)resizableImageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction;

@end

#pragma mark - Categories

/**
 * Adding `UICornerInset` support to `NSValue`.
 **/
@interface NSValue (NSValueUICornerInsetExtensions)

/**
 * Creates a `NSValue` from a `UICornerInset`.
 * @param cornerInset The corner inset.
 * @return A `NSValue` representation of the corner inset.
 **/
+ (NSValue*)valueWithUICornerInset:(UICornerInset)cornerInset;

/**
 * Retreives the `UICornerInset` value.
 * @return A the corner inset value.
 **/
- (UICornerInset)UICornerInsetValue;

@end
