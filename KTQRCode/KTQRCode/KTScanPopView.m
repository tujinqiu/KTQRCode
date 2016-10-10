//
//  KTScanPopView.m
//  KTImageVideoDemo
//
//  Created by kevin.tu on 16/4/11.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import "KTScanPopView.h"

@interface KTScanPopView ()

@property (nonatomic, strong) UIImageView *scanBar;
@property (nonatomic, strong) NSTimer *animateTimer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *scanRectView;

@end

@implementation KTScanPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layout];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layout];
    if (self.animateTimer) {
        [self stopAnimateScanBar];
        [self startAnimateScanBar];
    }
}

- (BOOL)isAnimating
{
    return self.animateTimer;
}

- (void)layout
{
    CGSize size = self.frame.size;
    CGFloat width = size.width < size.height ? size.width : size.height;
    width = width / 3.0 * 2.0;
    _scanFrame = CGRectMake((size.width - width) / 2.0, (size.height - width) / 2.0, width, width);
    // 创建阴影layer
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        [self.shapeLayer setFillRule:kCAFillRuleEvenOdd];
        [self.shapeLayer setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.5] CGColor]];
        [self.layer addSublayer:self.shapeLayer];
    }
    self.shapeLayer.frame = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cutoutPath = [UIBezierPath bezierPathWithRect:_scanFrame];
    [maskPath appendPath:cutoutPath];
    self.shapeLayer.path = maskPath.CGPath;
    // 创建四个角
    if (!self.scanRectView) {
        self.scanRectView = [[UIView alloc] initWithFrame:_scanFrame];
        self.scanRectView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scanRectView];
        CGFloat cornerWidth = 18.0, cornerHeight = 2.0;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cornerWidth, cornerHeight)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cornerHeight, cornerWidth)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(_scanFrame.size.width - cornerWidth, 0, cornerWidth, cornerHeight)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(_scanFrame.size.width - cornerHeight, 0, cornerHeight, cornerWidth)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(_scanFrame.size.width - cornerWidth, _scanFrame.size.height - cornerHeight, cornerWidth, cornerHeight)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(_scanFrame.size.width - cornerHeight, _scanFrame.size.height - cornerWidth, cornerHeight, cornerWidth)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, _scanFrame.size.height - cornerHeight, cornerWidth, cornerHeight)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, _scanFrame.size.height - cornerWidth, cornerHeight, cornerWidth)];
        view.backgroundColor = [UIColor greenColor];
        [self.scanRectView addSubview:view];
        // scan bar
        self.scanBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scanFrame.size.width, 8)];
        self.scanBar.image = [UIImage imageNamed:[@"KTQRCode.bundle" stringByAppendingPathComponent:@"KTCodeScanLine.png"]];
        [self.scanRectView addSubview:self.scanBar];
    }
    self.scanRectView.frame = _scanFrame;
}

- (void)startAnimateScanBar
{
    if (self.animateTimer) {
        [self.animateTimer invalidate];
    }
    self.animateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animateScanBar) userInfo:nil repeats:YES];
    [self animateScanBar];
}

- (void)stopAnimateScanBar
{
    if (self.animateTimer) {
        [self.animateTimer invalidate];
        self.animateTimer = nil;
        [self.scanBar.layer removeAllAnimations];
    }
}

- (void)animateScanBar
{
    self.scanBar.frame = CGRectMake(0, 0, _scanFrame.size.width, 8);
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scanBar.frame = CGRectMake(0, _scanFrame.size.height - 8, _scanFrame.size.width, 8);
    } completion:nil];
}

@end
