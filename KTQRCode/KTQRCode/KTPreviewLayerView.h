//
//  PreviewLayerView.h
//  KTImageVideoDemo
//
//  Created by kevin.tu on 16/4/12.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface KTPreviewLayerView : UIView

- (void)configWithSession:(AVCaptureSession *)session;

@end
