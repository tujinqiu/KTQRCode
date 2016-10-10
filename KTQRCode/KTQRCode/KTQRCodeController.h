//
//  KTQRCodeController.h
//  KTQRCode
//
//  Created by whkevin on 2016/10/10.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTQRCodeController;

@protocol KTQRCodeControllerDelegate <NSObject>

@optional
- (void)QRCodeController:(KTQRCodeController *)QRCodeController didScanResult:(NSString *)result;

@end

@interface KTQRCodeController : UINavigationController

@property (nonatomic, weak) id<KTQRCodeControllerDelegate> QRCodeDelegate;

+ (instancetype)QRCodeController;

@end
