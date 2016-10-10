//
//  KTPreviewLayerView.m
//  KTImageVideoDemo
//
//  Created by kevin.tu on 16/4/12.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import "KTPreviewLayerView.h"

@implementation KTPreviewLayerView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (void)configWithSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)(self.layer);
    [layer setSession:session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

@end
