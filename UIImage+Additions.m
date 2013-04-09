//
//  UIImage+Additions.m
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//
#import "UIImage+Additions.h"
#import "NSString+MD5Hashing.h"

const UICornerInset UICornerInsetZero = {0.0f, 0.0f, 0.0f, 0.0f};

NSString* NSStringFromUICornerInset(UICornerInset cornerInset)
{
    return [NSString stringWithFormat:@"UICornerInset <topLeft:%f> <topRight:%f> <bottomLeft:%f> <bottomRight:%f>",cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight];
}

static NSCache *_imageCache = nil;

@implementation UIImage (Additions)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    return [self imageWithColor:color size:size cornerInset:UICornerInsetZero];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithColor:color size:size cornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset
{
    return [self _imageWithColor:color size:size cornerInset:cornerInset saveInCache:YES];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color
{
    return [self resizableImageWithColor:color cornerInset:UICornerInsetZero];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius
{
    return [self resizableImageWithColor:color cornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerInset:(UICornerInset)cornerInset
{
    if (!color)
        return nil;
    
    NSArray *descriptors = @[color, @YES, [NSValue valueWithUICornerInset:cornerInset]];
    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    if (image)
        return image;
    
    CGSize size = CGSizeMake(MAX(cornerInset.topLeft, cornerInset.bottomLeft) + MAX(cornerInset.topRight, cornerInset.bottomRight) + 1,
                             MAX(cornerInset.topLeft, cornerInset.topRight) + MAX(cornerInset.bottomLeft, cornerInset.bottomRight) + 1);
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(MAX(cornerInset.topLeft, cornerInset.topRight),
                                              MAX(cornerInset.topLeft, cornerInset.bottomLeft),
                                              MAX(cornerInset.bottomLeft, cornerInset.bottomRight),
                                              MAX(cornerInset.topRight, cornerInset.bottomRight));
    
    image = [[self imageWithColor:color size:size cornerInset:cornerInset] resizableImageWithCapInsets:capInsets];
    
    [self _cacheImage:image withDescriptors:descriptors];
    
    return image;
}

+ (UIImage*)imageNamed:(NSString *)name tintColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle
{
    if (!name)
        return nil;

    UIImage *image = [UIImage imageNamed:name];
    
    if (!image)
        return nil;
    
    NSArray *descriptors = @[name, color, @(tintStyle)];
    UIImage *tintedImage = [self _cachedImageWithDescriptors:descriptors];
    
    if (!tintedImage)
    {
        tintedImage = [image tintedImageWithColor:color style:tintStyle];
        [self _cacheImage:tintedImage withDescriptors:descriptors];
    }
    
    return tintedImage;
}

- (UIImage*)tintedImageWithColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle
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

    if (tintStyle == UIImageTintedStyleOverAlpha)
    {
        [color setFill];
        CGContextFillRect(context, rect);
    }
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);

    if (tintStyle == UIImageTintedStyleKeepingAlpha)
    {
        CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        [color setFill];
        CGContextFillRect(context, rect);
    }
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

- (UIImage*)imageWithRoundedBounds
{    
    CGSize size = self.size;
    CGFloat radius = MIN(size.width, size.height) / 2.0;
    return [self imageWithCornerRadius:radius];
}

- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithCornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)imageWithCornerInset:(UICornerInset)cornerInset
{
    if (![self isValidCornerInset:cornerInset])
        return nil;
    
    CGFloat scale = self.scale;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*self.size.width, scale*self.size.height);
        
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
        
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
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

- (BOOL)isValidCornerInset:(UICornerInset)cornerInset
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

- (UIImage *)imageAddingImage:(UIImage*)image offset:(CGPoint)offset
{
    CGSize size = self.size;
    size.width *= self.scale;
    size.height *= self.scale;
    
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake( 0, 0, size.width, size.height )];
    [image drawInRect:CGRectMake(offset.x, offset.y, size.width, size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    UIImage *destImage = [UIImage imageWithCGImage:bitmapContext scale:image.scale orientation:UIImageOrientationUp];
    CGContextRelease(context);
    CGImageRelease(bitmapContext);
    
    return destImage;
}

#pragma mark Private Methods

+ (NSCache*)_cache
{
    if (!_imageCache)
        _imageCache = [[NSCache alloc] init];
    
    return _imageCache;
}

+ (UIImage*)_cachedImageWithDescriptors:(NSArray*)descriptors
{
    NSString *key = [self _keyForImageWithDescriptors:descriptors];
    
    return [[self _cache] objectForKey:key];
}

+ (void)_cacheImage:(UIImage*)image withDescriptors:(NSArray*)descriptors
{
    NSString *key = [self _keyForImageWithDescriptors:descriptors];
    [[self _cache] setObject:image forKey:key];
}

+ (NSString*)_keyForImageWithDescriptors:(NSArray*)descriptors
{
    NSMutableString *string = [NSMutableString string];
    
    for (id object in descriptors)
    {        
        if ([object isKindOfClass:[NSNumber class]])
        {
            [string appendFormat:@"%d-",[object integerValue]];
        }
        else if ([object isKindOfClass:[NSValue class]])
        {
            NSValue *value = object;
                        
            if (strcmp((const char *)@encode(CGSize), (const char *)value.objCType) == 0)
            {
                CGSize size = [value CGSizeValue];
                [string appendFormat:@"%d-%d",(int)size.width, (int)size.height];
            }
            else if (strcmp(@encode(CGPoint), value.objCType) == 0)
            {
                CGPoint point = [value CGPointValue];
                [string appendFormat:@"%d-%d-",(int)point.x, (int)point.y];
            }
            else if (strcmp(@encode(CGRect), value.objCType) == 0)
            {
                CGRect rect = [value CGRectValue];
                [string appendFormat:@"%d-%d-%d-%d-",(int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height];
            }
            else if (strcmp(@encode(UICornerInset), value.objCType) == 0)
            {
                UICornerInset cornerInset = [value UICornerInsetValue];
                [string appendFormat:@"%d-%d-%d-%d-",(int)cornerInset.topLeft, (int)cornerInset.topRight, (int)cornerInset.bottomLeft, (int)cornerInset.bottomRight];
            }
        }
        else
        {
            [string appendFormat:@"%d-",[object hash]];
        }
    }
    
    return [string md5];
}

+ (UIImage*)_imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset saveInCache:(BOOL)save
{
    NSArray *descriptors = @[color, [NSValue valueWithCGSize:size], @NO, [NSValue valueWithUICornerInset:cornerInset]];

    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    
    if (image)
        return image;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*size.width, scale*size.height);
    
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
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
        [self _cacheImage:theImage withDescriptors:descriptors];
    
    return theImage;
}

@end

#pragma mark - Categories

@implementation NSValue (UICornerInset)

+ (NSValue*)valueWithUICornerInset:(UICornerInset)cornerInset
{
    CGRect rect = CGRectMake(cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight);
    return [NSValue valueWithCGRect:rect];
    
    //    UICornerInset inset = cornerInset;
    //    return [[NSValue alloc] initWithBytes:&inset objCType:@encode(struct __UICornerInset)];
}

- (UICornerInset)UICornerInsetValue
{
    CGRect rect = [self CGRectValue];
    return UICornerInsetMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    //    UICornerInset cornerInset;
    //    [self getValue:&cornerInset];
    //    return cornerInset;
}

@end
