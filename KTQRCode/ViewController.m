//
//  ViewController.m
//  KTQRCode
//
//  Created by whkevin on 2016/10/10.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import "ViewController.h"
#import "KTQRCodeController.h"

@interface ViewController ()<KTQRCodeControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapQRButton:(id)sender {
    KTQRCodeController *nav = [KTQRCodeController QRCodeController];
    nav.QRCodeDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)QRCodeController:(KTQRCodeController *)QRCodeController didScanResult:(NSString *)result
{
    [QRCodeController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"result:%@", result);
}

@end
