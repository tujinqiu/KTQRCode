//
//  KTQRCodeController.m
//  KTQRCode
//
//  Created by whkevin on 2016/10/10.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import "KTQRCodeController.h"
#import "KTQRCodeViewController.h"

@interface KTQRCodeController ()

@end

@implementation KTQRCodeController

+ (instancetype)QRCodeController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"KTQRCode" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
