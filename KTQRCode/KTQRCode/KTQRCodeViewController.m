//
//  KTQRCodeViewController.m
//  KTQRCode
//
//  Created by whkevin on 2016/10/10.
//  Copyright © 2016年 ovwhkevin0461. All rights reserved.
//

#import "KTQRCodeViewController.h"
#import "KTQRCodeController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAlertController+Simple.h"
#import "KTScanPopView.h"
#import "KTPreviewLayerView.h"

@interface KTQRCodeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) KTScanPopView *popView;
@property (weak, nonatomic) IBOutlet KTPreviewLayerView *previewLayerView;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@end

@implementation KTQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.popView = [[KTScanPopView alloc] initWithFrame:frame];
    [self.view addSubview:self.popView];
    self.popView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startScan
{
    [self.popView startAnimateScanBar];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    NSParameterAssert(input);
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:output];
    dispatch_queue_t queue = dispatch_queue_create("KTScanViewControllerScanQueue", DISPATCH_QUEUE_SERIAL);
    [output setMetadataObjectsDelegate:self queue:queue];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect outputFrame = self.popView.scanFrame;
    [output setRectOfInterest:CGRectMake(outputFrame.origin.y / size.height, outputFrame.origin.x / size.width, outputFrame.size.height / size.height, outputFrame.size.width / size.width)];
    [self.previewLayerView configWithSession:self.captureSession];
    [self.captureSession startRunning];
}

- (void)stopScan
{
    [self.popView stopAnimateScanBar];
    if (self.captureSession) {
        [self.captureSession stopRunning];
        self.captureSession = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopScan];
}

- (IBAction)tapCancelButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapAlbumQRCodeButton:(id)sender {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied || author == ALAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController simpleAlertControllerWithTitle:@"提示" message:@"因iOS系统限制，开启照片服务才能选取\n步骤：设置->绚拍->照片" cancel:@"取消" button:@"去设置" handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else {
            UIAlertController *alert = [UIAlertController simpleAlertControllerWithTitle:@"错误" message:@"照片库不可用" cancel:@"好的"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }

}

- (void)readQRCodeFromImage:(UIImage *)image result:(void (^)(NSString *resultString))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyHigh, CIDetectorAccuracy, nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
        NSArray *features = [detector featuresInImage:ciImage];
        NSString *str = nil;
        if (features.count > 0) {
            CIQRCodeFeature *feature = [features firstObject];
            str = feature.messageString;
        }
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(str);
            });
        }
    });
}

- (void)showReadQRCodeError
{
    UIAlertController *alert = [UIAlertController simpleAlertControllerWithTitle:@"错误" message:@"识别不到二维码，请选取包含正确二维码的照片" cancel:nil button:@"好的" handler:^(UIAlertAction *action) {
        // 重启扫描
        [self startScan];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate --

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects firstObject];
        NSString *result = nil;
        if ([[obj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = obj.stringValue;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self stopScan];
            KTQRCodeController *controller = (KTQRCodeController *)self.navigationController;
            if (result && [controller.QRCodeDelegate respondsToSelector:@selector(QRCodeController:didScanResult:)]) {
                [controller.QRCodeDelegate QRCodeController:controller didScanResult:result];
            }
        });
    }
}

#pragma mark -- UIImagePickerControllerDelegate --

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self readQRCodeFromImage:image result:^(NSString *result) {
            if (result) {
                KTQRCodeController *controller = (KTQRCodeController *)self.navigationController;
                if ([controller.QRCodeDelegate respondsToSelector:@selector(QRCodeController:didScanResult:)]) {
                    [controller.QRCodeDelegate QRCodeController:controller didScanResult:result];
                }
            } else {
                [self showReadQRCodeError];
            }
        }];
    } else {
        [self showReadQRCodeError];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 重启扫描
    [self startScan];
}

@end
