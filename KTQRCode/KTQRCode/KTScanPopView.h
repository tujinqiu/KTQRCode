//
//  KTScanPopView.h
//  KTImageVideoDemo
//
//  Created by kevin.tu on 16/4/11.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTScanPopView : UIView

@property (nonatomic, assign, readonly) CGRect scanFrame;
@property (nonatomic, assign, readonly) BOOL isAnimating;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)startAnimateScanBar;
- (void)stopAnimateScanBar;

@end
