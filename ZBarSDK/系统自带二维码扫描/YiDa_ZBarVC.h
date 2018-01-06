//
//  YiDa_ZBarVC.h
//  ZBarSDK
//
//  Created by 钱老师 on 14-7-5.
//  Copyright (c) 2014年 钱老师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YiDa_ZBarVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    int _num;
    BOOL _isUP;//判断扫描线向上还是向下运动
}

//设置相机设备捕获属性
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIImageView *line;//设置二维码扫描线
@property (nonatomic, strong) NSTimer *timer;//定时器


@end
