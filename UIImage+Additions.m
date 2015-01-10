//
//  UIImage+Additions.m
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

#import "UIImage+Additions.h"

@interface NSString (MD5Hashing)

- (NSString*)md5;

@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Hashing)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end

const ADDCornerInset ADDCornerInsetZero = {0.0f, 0.0f, 0.0f, 0.0f};

NSString* NSStringFromADDCornerInset(ADDCornerInset cornerInset)
{
    return [NSString stringWithFormat:@"ADDCornerInset <topLeft:%f> <topRight:%f> <bottomLeft:%f> <bottomRight:%f>",cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight];
}

static NSCache * _imageCache = nil;

static NSString * kUIImageName = @"kUIImageName";
static NSString * kUIImageResizableImage = @"kUIImageResizableImage";
static NSString * kUIImageColors = @"kUIImageColors";
static NSString * kUIImageTintColor = @"kUIImageTintColor";
static NSString * kUIImageTintStyle = @"kUIImageTintStyle";
static NSString * kUIImageCornerInset = @"kUIImageCornerInset";
static NSString * kADDImageGradientDirection = @"kADDImageGradientDirection";
static NSString * kUIImageSize = @"kUIImageSize";

@implementation UIImage (Additions)

+ (UIImage*)add_imageWithColor:(UIColor*)color
{
    return [self add_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size
{
    return [self add_imageWithColor:color size:size cornerInset:ADDCornerInsetZero];
}

+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    return [self add_imageWithColor:color size:size cornerInset:ADDCornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(ADDCornerInset)cornerInset
{
    return [self add_imageWithColor:color size:size cornerInset:cornerInset saveInCache:YES];
}

+ (UIImage*)add_resizableImageWithColor:(UIColor*)color
{
    return [self add_resizableImageWithColor:color cornerInset:ADDCornerInsetZero];
}

+ (UIImage*)add_resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius
{
    return [self add_resizableImageWithColor:color cornerInset:ADDCornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)add_resizableImageWithColor:(UIColor*)color cornerInset:(ADDCornerInset)cornerInset
{
    if (!color)
        return nil;
    
    NSDictionary *descriptors =  @{kUIImageColors : @[color],
                                   kUIImageResizableImage : @YES,
                                   kUIImageCornerInset : [NSValue valueWithADDCornerInset:cornerInset]};
    
    UIImage *image = [self add_cachedImageWithDescriptors:descriptors];
    
    if (image)
        return image;
    
    CGSize size = CGSizeMake(MAX(cornerInset.topLeft, cornerInset.bottomLeft) + MAX(cornerInset.topRight, cornerInset.bottomRight) + 1,
                             MAX(cornerInset.topLeft, cornerInset.topRight) + MAX(cornerInset.bottomLeft, cornerInset.bottomRight) + 1);
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(MAX(cornerInset.topLeft, cornerInset.topRight),
                                              MAX(cornerInset.topLeft, cornerInset.bottomLeft),
                                              MAX(cornerInset.bottomLeft, cornerInset.bottomRight),
                                              MAX(cornerInset.topRight, cornerInset.bottomRight));
    
    image = [[self add_imageWithColor:color size:size cornerInset:cornerInset] resizableImageWithCapInsets:capInsets];
    
    [self add_cacheImage:image withDescriptors:descriptors];
    
    return image;
}

+ (UIImage*)add_blackColorImage
{
    return [self add_resizableImageWithColor:[UIColor blackColor]];
}

+ (UIImage*)add_darkGrayColorImage
{
    return [self add_resizableImageWithColor:[UIColor darkGrayColor]];
}

+ (UIImage*)add_lightGrayColorImage
{
    return [self add_resizableImageWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)add_whiteColorImage
{
    return [self add_resizableImageWithColor:[UIColor whiteColor]];
}

+ (UIImage*)add_grayColorImage
{
    return [self add_resizableImageWithColor:[UIColor grayColor]];
}

+ (UIImage*)add_redColorImage
{
    return [self add_resizableImageWithColor:[UIColor redColor]];
}

+ (UIImage*)add_greenColorImage
{
    return [self add_resizableImageWithColor:[UIColor greenColor]];
}

+ (UIImage*)add_blueColorImage
{
    return [self add_resizableImageWithColor:[UIColor blueColor]];
}

+ (UIImage*)add_cyanColorImage
{
    return [self add_resizableImageWithColor:[UIColor cyanColor]];
}

+ (UIImage*)add_yellowColorImage
{
    return [self add_resizableImageWithColor:[UIColor yellowColor]];
}

+ (UIImage*)add_magentaColorImage
{
    return [self add_resizableImageWithColor:[UIColor magentaColor]];
}

+ (UIImage*)add_orangeColorImage
{
    return [self add_resizableImageWithColor:[UIColor orangeColor]];
}

+ (UIImage*)add_purpleColorImage
{
    return [self add_resizableImageWithColor:[UIColor purpleColor]];
}

+ (UIImage*)add_brownColorImage
{
    return [self add_resizableImageWithColor:[UIColor brownColor]];
}

+ (UIImage*)add_clearColorImage
{
    return [self add_resizableImageWithColor:[UIColor clearColor]];
}

+ (UIImage*)add_imageNamed:(NSString *)name tintColor:(UIColor*)color style:(ADDImageTintStyle)tintStyle
{
    if (!name)
        return nil;

    UIImage *image = [UIImage imageNamed:name];
    
    if (!image)
        return nil;
    
    if (!color)
        return image;
    
    NSDictionary *descriptors =  @{kUIImageName : name,
                                   kUIImageTintColor : color,
                                   kUIImageTintStyle : @(tintStyle)};
    
    UIImage *tintedImage = [self add_cachedImageWithDescriptors:descriptors];
    
    if (!tintedImage)
    {
        tintedImage = [image add_tintedImageWithColor:color style:tintStyle];
        [self add_cacheImage:tintedImage withDescriptors:descriptors];
    }
    
    return tintedImage;
}

- (UIImage*)add_tintedImageWithColor:(UIColor*)color style:(ADDImageTintStyle)tintStyle
{
    if (!color)
        return self;
    
    CGFloat scale = self.scale;
    CGSize size = CGSizeMake(scale * self.size.width, scale * self.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // ---

    if (tintStyle == ADDImageTintStyleKeepingAlpha)
    {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        [color setFill];
        CGContextFillRect(context, rect);
    }
    else if (tintStyle == ADDImageTintStyleOverAlpha)
    {
        [color setFill];
        CGContextFillRect(context, rect);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextDrawImage(context, rect, self.CGImage);
    }
    else if (tintStyle == ADDImageTintStyleOverAlphaExtreme)
    {
        [color setFill];
        CGContextFillRect(context, rect);
        CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
        CGContextDrawImage(context, rect, self.CGImage);
    }
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

- (UIImage*)add_imageWithRoundedBounds
{    
    CGSize size = self.size;
    CGFloat radius = MIN(size.width, size.height) / 2.0;
    return [self add_imageWithCornerRadius:radius];
}

- (UIImage*)add_imageWithCornerRadius:(CGFloat)cornerRadius
{
    return [self add_imageWithCornerInset:ADDCornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)add_imageWithCornerInset:(ADDCornerInset)cornerInset
{
    if (![self add_isValidCornerInset:cornerInset])
        return nil;
    
    CGFloat scale = self.scale;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*self.size.width, scale*self.size.height);
        
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
        return nil;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGImageRef bitmapImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:bitmapImageRef scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapImageRef);

    return newImage;
}

- (BOOL)add_isValidCornerInset:(ADDCornerInset)cornerInset
{
    CGSize size = self.size;
    
    BOOL isValid = YES;
    
    if (cornerInset.topLeft + cornerInset.topRight > size.width)
        isValid = NO;
    
    else if (cornerInset.topRight + cornerInset.bottomRight > size.height)
        isValid = NO;
    
    else if (cornerInset.bottomRight + cornerInset.bottomLeft > size.width)
        isValid = NO;
    
    else if (cornerInset.bottomLeft + cornerInset.topLeft > size.height)
        isValid = NO;
    
    return isValid;
}

- (UIImage*)add_imageAddingImage:(UIImage*)image
{
    CGSize size1 = self.size;
    CGSize size2 = image.size;
    
    CGPoint offset = CGPointMake(floorf((size1.width - size2.width)/2.0),
                                 floorf((size1.height - size2.height)/2.0));
    return [self add_imageAddingImage:image offset:offset];
}

- (UIImage*)add_imageAddingImage:(UIImage*)image offset:(CGPoint)offset
{
    CGSize size = self.size;
    CGFloat scale = self.scale;
    
    size.width *= scale;
    size.height *= scale;
    
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake( 0, 0, size.width, size.height)];
    
    [image drawInRect:CGRectMake(scale * offset.x, scale * offset.y, image.size.width * scale, image.size.height * scale)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    UIImage *destImage = [UIImage imageWithCGImage:bitmapContext scale:image.scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    CGImageRelease(bitmapContext);
    
    return destImage;
}

#pragma mark Private Methods

+ (NSCache*)add_cache
{
    if (!_imageCache)
        _imageCache = [[NSCache alloc] init];
    
    return _imageCache;
}

+ (UIImage*)add_cachedImageWithDescriptors:(NSDictionary*)descriptors
{
    return [[self add_cache] objectForKey:[self add_keyForImageWithDescriptors:descriptors]];
}

+ (void)add_cacheImage:(UIImage*)image withDescriptors:(NSDictionary*)descriptors
{
    NSString *key = [self add_keyForImageWithDescriptors:descriptors];
    [[self add_cache] setObject:image forKey:key];
}

+ (NSString*)add_keyForImageWithDescriptors:(NSDictionary*)descriptors
{
    NSMutableString *string = [NSMutableString string];
    
    NSString *imageName = [descriptors valueForKey:kUIImageName];
    [string appendFormat:@"<%@:%@>",kUIImageName,(imageName == nil)?@"":imageName];
    [string appendFormat:@"<%@:%@>",kUIImageSize, NSStringFromCGSize([[descriptors valueForKey:kUIImageSize] CGSizeValue])];
    [string appendFormat:@"<%@:%d>",kUIImageResizableImage,[[descriptors valueForKey:kUIImageResizableImage] boolValue]];
    
    [string appendFormat:@"<%@:",kUIImageColors];
    NSArray *colors = [descriptors valueForKey:kUIImageColors];
    for (UIColor *color in colors)
        [string appendFormat:@"%ld",(long)color.hash];
    [string appendFormat:@">"];
    
    [string appendFormat:@"<%@:%ld>",kUIImageTintColor,(long)[[descriptors valueForKey:kUIImageTintColor] hash]];
    [string appendFormat:@"<%@:%ld>",kUIImageTintStyle,(long)[[descriptors valueForKey:kUIImageTintStyle] integerValue]];
    [string appendFormat:@"<%@:%@>",kUIImageCornerInset,NSStringFromADDCornerInset([[descriptors valueForKey:kUIImageCornerInset] ADDCornerInsetValue])];
    [string appendFormat:@"<%@:%ld>",kADDImageGradientDirection,(long)[[descriptors valueForKey:kADDImageGradientDirection] integerValue]];
    
    return [string md5];
}

+ (UIImage*)add_imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(ADDCornerInset)cornerInset saveInCache:(BOOL)save
{
    NSDictionary *descriptors =  @{kUIImageColors : @[color],
                                   kUIImageSize : [NSValue valueWithCGSize:size],
                                   kUIImageCornerInset : [NSValue valueWithADDCornerInset:cornerInset]};

    UIImage *image = [self add_cachedImageWithDescriptors:descriptors];
    
    if (image)
        return image;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*size.width, scale*size.height);
    
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
        return nil;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 1.0, 0.0); // <-- Alpha color in background
    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetFillColorWithColor(context, [color CGColor]); // <-- Color to fill
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    if (save)
        [self add_cacheImage:theImage withDescriptors:descriptors];
    
    return theImage;
}

+ (UIImage*)add_imageWithGradient:(NSArray*)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction
{
    NSDictionary *descriptors = @{kUIImageColors: colors,
                                  kUIImageSize: [NSValue valueWithCGSize:size],
                                  kADDImageGradientDirection: @(direction)};
    
    UIImage *image = [self add_cachedImageWithDescriptors:descriptors];
    if (image)
        return image;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create Gradient
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors)
        [cgColors addObject:(id)color.CGColor];
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)cgColors, NULL);
    
    // Apply gradient
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (direction == ADDImageGradientDirectionVertical)
    {
        endPoint = CGPointMake(0, rect.size.height);
    }
    else if (direction == ADDImageGradientDirectionHorizontal)
    {
        endPoint = CGPointMake(rect.size.width, 0);
    }
    else if (direction == ADDImageGradientDirectionLeftSlanted)
    {
        endPoint = CGPointMake(rect.size.width, rect.size.height);
    }
    else if (direction == ADDImageGradientDirectionRightSlanted)
    {
        startPoint = CGPointMake(rect.size.width, 0);
        endPoint = CGPointMake(0, rect.size.height);
    }
        
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean memory & End context
    UIGraphicsEndImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    [self add_cacheImage:image withDescriptors:descriptors];
    
    return image;
}

+ (UIImage*)add_resizableImageWithGradient:(NSArray*)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction
{
    if ((size.width == 0.0f && direction == ADDImageGradientDirectionHorizontal) ||
        (size.height == 0.0f && direction == ADDImageGradientDirectionVertical) ||
        (size.height == 0.0f && size.width == 0.0f))
        return nil;
    
    NSDictionary *descriptors = @{kUIImageColors: colors,
                                  kUIImageSize: [NSValue valueWithCGSize:size],
                                  kADDImageGradientDirection: @(direction),
                                  kUIImageResizableImage: @YES};
    
    UIImage *image = [self add_cachedImageWithDescriptors:descriptors];
    if (image)
        return image;
    
    CGSize imageSize = CGSizeMake(1.0f, 1.0f);
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (direction == ADDImageGradientDirectionVertical)
    {
        imageSize.height = size.height;
        insets = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
    }
    else if (direction == ADDImageGradientDirectionHorizontal)
    {
        imageSize.width = size.width;
        insets = UIEdgeInsetsMake(1.0f, 0.0f, 1.0f, 0.0f);
    }
    else
    {
        imageSize.width = size.width;
        imageSize.height = size.height;
        insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    return [[self add_imageWithGradient:colors size:imageSize direction:direction] resizableImageWithCapInsets:insets];
}

@end

#pragma mark - Categories

@implementation NSValue (NSValueADDCornerInsetExtensions)

+ (NSValue*)valueWithADDCornerInset:(ADDCornerInset)cornerInset
{
    CGRect rect = CGRectMake(cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight);
    return [NSValue valueWithCGRect:rect];
    
    //    ADDCornerInset inset = cornerInset;
    //    return [[NSValue alloc] initWithBytes:&inset objCType:@encode(struct __ADDCornerInset)];
}

- (ADDCornerInset)ADDCornerInsetValue
{
    CGRect rect = [self CGRectValue];
    return ADDCornerInsetMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    //    ADDCornerInset cornerInset;
    //    [self getValue:&cornerInset];
    //    return cornerInset;
}

@end
