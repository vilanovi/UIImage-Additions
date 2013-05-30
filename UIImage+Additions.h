//
//  UIImage+Additions.h
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//

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

typedef enum __UIImageTintedStyle
{
    UIImageTintedStyleKeepingAlpha      = 1,
    UIImageTintedStyleOverAlpha         = 2
} UIImageTintedStyle;

typedef enum __UIImageGradientDirection
{
    UIImageGradientDirectionVertical    = 1,
    UIImageGradientDirectionHorizontal  = 2,
} UIImageGradientDirection;

@interface UIImage (Additions)

/*
 * Create images from colors
 */
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset;

/*
 * Create rezisable images from colors
 */
+ (UIImage*)resizableImageWithColor:(UIColor*)color;
+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius;
+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerInset:(UICornerInset)cornerInset;

/*
 * Tint Images
 */
+ (UIImage*)imageNamed:(NSString *)name tintColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle;
- (UIImage*)tintedImageWithColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle;

/*
 * Rounding corners
 */
- (UIImage*)imageWithRoundedBounds;
- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius;
- (UIImage*)imageWithCornerInset:(UICornerInset)cornerInset;
- (BOOL)isValidCornerInset:(UICornerInset)cornerInset;

/*
 * Drawing image on image
 */
- (UIImage*)imageAddingImage:(UIImage*)image offset:(CGPoint)offset;

/*
 * Gradient image generation
 */
+ (UIImage*)imageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction;
+ (UIImage*)resizableImageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction;

@end

#pragma mark - Categories

@interface NSValue (UICornerInset)

+ (NSValue*)valueWithUICornerInset:(UICornerInset)cornerInset;
- (UICornerInset)UICornerInsetValue;

@end
