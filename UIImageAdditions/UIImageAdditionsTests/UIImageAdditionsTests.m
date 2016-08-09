//
//  UIImageAdditionsTests.m
//  UIImageAdditionsTests
//
//  Created by Joan Martin on 10/01/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIImage+Additions.h"

@interface UIImageAdditionsTests : XCTestCase
@property(nonatomic, strong) UIImage *testImage;
@end

@implementation UIImageAdditionsTests

- (void)setUp {
    [super setUp];
    
    self.testImage = [[UIImage alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testImage = nil;
    
    [super tearDown];
}

- (void)test_add_image_passing_NilColor_returns_nilImage {
    UIImage *sut = [UIImage add_imageWithColor:nil];
    XCTAssertNil(sut);
}

- (void)test_add_imageWithColor_returns_valid1x1pixel_image_with_nil_color {
    UIImage *sut = [UIImage add_imageWithColor:[UIColor greenColor]];
    XCTAssertNotNil(sut);
    XCTAssertEqual(1, sut.size.width);
    XCTAssertEqual(1, sut.size.height);
}

- (void)test_add_image_withColor_Size_passing_NilColor_returns_nilImage {
    UIImage *sut = [UIImage add_imageWithColor:nil size:CGSizeMake(10, 10)];
    XCTAssertNil(sut);
}

- (void)test_add_image_withColor_Size_passing_Color_ZeroSize_returns_nilImage {
    UIImage *sut = [UIImage add_imageWithColor:[UIColor blueColor] size:CGSizeZero];
    XCTAssertNil(sut);
}

- (void)test_add_image_withColor_Size_passing_Color_NonZeroSize_returns_ValidImage {
    UIImage *sut = [UIImage add_imageWithColor:[UIColor blueColor] size:CGSizeMake(10, 10)];
    XCTAssertNotNil(sut);
    XCTAssertEqual(10, sut.size.width);
    XCTAssertEqual(10, sut.size.height);
}

- (void)test_add_image_withColor_Size_CornerRadius_passing_NilColor_returns_nilImage {
    UIImage *sut = [UIImage add_imageWithColor:nil size:CGSizeMake(10, 10) cornerRadius:10];
    XCTAssertNil(sut);
}

- (void)test_add_image_withColor_Size_CornerRadius_passing_Color_ZeroSize_returns_nilImage {
    UIImage *sut = [UIImage add_imageWithColor:[UIColor blueColor] size:CGSizeZero cornerRadius:10];
    XCTAssertNil(sut);
}

- (void)test_add_image_withColor_Size_CornerRadius_passing_Color_NonZeroSize_returns_ValidImage {
    UIImage *sut = [UIImage add_imageWithColor:[UIColor blueColor] size:CGSizeMake(10, 10) cornerRadius:10];
    XCTAssertNotNil(sut);
    XCTAssertEqual(10, sut.size.width);
    XCTAssertEqual(10, sut.size.height);
}

- (void)test_addBasicColors {
    UIImage *sut;
    UIColor *colorInImage;
    
    sut = [UIImage add_blackColorImage];
    colorInImage = [self pixelColorInImage:sut atX:0 atY:0];

    BOOL areSameColorBlack = [self RGBComponentsInColor:[UIColor blackColor] areEqualToComponentsInColor:colorInImage];

    XCTAssertNotNil(sut);
    XCTAssertTrue(areSameColorBlack);
    
    sut = [UIImage add_redColorImage];
    colorInImage = [self pixelColorInImage:sut atX:0 atY:0];
    
    BOOL areSameColorRed = [self RGBComponentsInColor:[UIColor redColor] areEqualToComponentsInColor:colorInImage];
    
    XCTAssertNotNil(sut);
    XCTAssertTrue(areSameColorRed);
}

- (void)test_addImageWithVerticalGradient {
    UIColor *initColor = [UIColor blueColor];
    NSArray<UIColor *> *colours = @[ initColor, [UIColor yellowColor]];
    UIImage *sut = [UIImage add_imageWithGradient:colours size:CGSizeMake(100, 100) direction:ADDImageGradientDirectionVertical];
    
    XCTAssertNotNil(sut);
    UIColor *topRightPointColor = [self pixelColorInImage:sut atX:0 atY:99];
    BOOL areSameColor = [self RGBComponentsInColor:initColor areEqualToComponentsInColor:topRightPointColor];

    XCTAssertTrue(areSameColor);
}


#pragma mark - support

- (BOOL)RGBComponentsInColor:(UIColor *)colorA areEqualToComponentsInColor:(UIColor *)colorB {
    CGFloat aR = [self readRfromRGBColor:colorA];
    CGFloat aG = [self readGfromRGBColor:colorA];
    CGFloat aB = [self readBfromRGBColor:colorA];
    
    CGFloat bR = [self readRfromRGBColor:colorB];
    CGFloat bG = [self readGfromRGBColor:colorB];
    CGFloat bB = [self readBfromRGBColor:colorB];
    
    return aR == bR && aG == bG && aB == bB;
}

- (UIColor*)pixelColorInImage:(UIImage*)image atX:(int)x atY:(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width * y) + x ) * 4; // 4 bytes per pixel
    
    UInt8 red   = data[pixelInfo + 0];
    UInt8 green = data[pixelInfo + 1];
    UInt8 blue  = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);
    
    return [UIColor colorWithRed:red  /255.0f
                           green:green/255.0f
                            blue:blue /255.0f
                           alpha:alpha/255.0f];
}

- (CGFloat)readRfromRGBColor:(UIColor *)color {
    return [self readComponentFromColor:color index:0];
}

- (CGFloat)readGfromRGBColor:(UIColor *)color {
    return [self readComponentFromColor:color index:1];
}

- (CGFloat)readBfromRGBColor:(UIColor *)color {
    return [self readComponentFromColor:color index:2];
}

- (float)readComponentFromColor:(UIColor *)color index:(NSUInteger)index {
    if (index >0 || index > 3) {
        return -1;
    }
    
    return CGColorGetComponents(color.CGColor)[index];
}

@end
