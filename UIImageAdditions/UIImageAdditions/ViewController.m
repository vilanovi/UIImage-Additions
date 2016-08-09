//
//  ViewController.m
//  UIImageAdditions
//
//  Created by Joan Martin on 10/01/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Additions.h"


@interface ViewController ()
@property (nonatomic) NSUInteger nextDemoPointer;
@property (nonatomic, strong) NSArray *nextDemo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNextDemoEffect)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)nextDemo {
    return @[
             NSStringFromSelector(@selector(addBlueToYellowVerticalGradient)),
             NSStringFromSelector(@selector(addRedToYellowLeftSlantedGradient)),
             NSStringFromSelector(@selector(addBlackToGreenRightSlantedGradient)),
             NSStringFromSelector(@selector(addGradient))
             ];
}

- (void)showNextDemoEffect {
    SEL method = NSSelectorFromString(self.nextDemo[self.nextDemoPointer]);
    [self performSelector:method];
    
    self.nextDemoPointer = ++self.nextDemoPointer % self.nextDemo.count;
}

- (void)addBlueToYellowVerticalGradient {
    NSArray<UIColor *> *colours = @[ [UIColor blueColor], [UIColor yellowColor]];
    [self addGradient:colours direction:ADDImageGradientDirectionVertical];
}

- (void)addRedToYellowLeftSlantedGradient {
    NSArray<UIColor *> *colours = @[ [UIColor redColor], [UIColor yellowColor]];
    [self addGradient:colours direction:ADDImageGradientDirectionLeftSlanted];
}

- (void)addBlackToGreenRightSlantedGradient {
    NSArray<UIColor *> *colours = @[ [UIColor blackColor], [UIColor greenColor]];
    [self addGradient:colours direction:ADDImageGradientDirectionRightSlanted];
}

- (void)addGradient {
    NSArray<UIColor *> *colours = @[ [UIColor colorWithRed:230/255.0 green:142/255.0 blue:36/255.0 alpha:1.0], [UIColor colorWithRed:125/255.0 green:46/255.0 blue:80/255.0 alpha:1.0]];
    [self addGradient:colours direction:ADDImageGradientDirectionLeftSlanted];
}


- (void)addGradient:(NSArray<UIColor *> *)colours direction:(ADDImageGradientDirection)direction {
    UIImage *background = [UIImage add_imageWithGradient:colours size:self.view.bounds.size direction:direction];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
    [backgroundView setFrame:self.view.frame];
    
    [self.view addSubview:backgroundView];
}


@end
