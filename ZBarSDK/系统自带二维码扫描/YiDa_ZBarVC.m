//
//  YiDa_ZBarVC.m
//  ZBarSDK
//
//  Created by 钱老师 on 14-7-5.
//  Copyright (c) 2014年 钱老师. All rights reserved.
//

#import "YiDa_ZBarVC.h"

@interface YiDa_ZBarVC ()

@end

@implementation YiDa_ZBarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setTitle:@"取消扫描" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(100, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    lab.backgroundColor = [UIColor clearColor];
    lab.numberOfLines = 2;
    lab.textColor = [UIColor whiteColor];
    lab.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:lab];
    
    //二维码扫描框背景
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    //二维码扫描线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 110, 260, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    
    //初始化动画参数
    _num = 0;
    _isUP = NO;
    
    //启动定时器，让扫描线上下浮动
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                  target:self
                                                selector:@selector(animation)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginScan];//开始扫描
}

//创建二维码扫描动画界面
- (void)animation
{
    if (_isUP == NO)
    {
        _num++;
        int tmpY = _num*2;
        self.line.frame = CGRectMake(30, 110+tmpY, 260, 2);
        if (tmpY == 280)
        {
            _isUP = YES;
        }
    }
    else
    {
        _num--;
        int tmpY = _num*2;
        self.line.frame = CGRectMake(30, 110+tmpY, 260, 2);
        if (_num == 0)
        {
            _isUP = NO;
        }
    }
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.timer invalidate];
        self.timer = nil;
    }];
}

//开始扫瞄
- (void)beginScan
{
    // 创建捕获设备Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 创建输入设备Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 创建输出设备Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 创建会话Session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];//设置会话质量(高清)
    if ([self.session canAddInput:self.input])//能否添加输入设备
    {
        [self.session addInput:self.input];//会话中添加输入设备
    }
    
    if ([self.session canAddOutput:self.output])//能否添加输出设备
    {
        [self.session addOutput:self.output];//会话中添加输出设备
    }
    
    // 设置条码类型 AVMetadataObjectTypeQRCode(二维码)
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // 创建捕获录像遮照层Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;//等比填充
    self.preview.frame =CGRectMake(20,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];//当前视图插入遮照层Preview
    
    // 开始启动会话Start
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//二维码扫描结果回调方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_session stopRunning];// 停止当前会话Stop
    
    [self.timer invalidate];//停止定时器
    self.timer = nil;//释放定时器对象
    
    //获取扫描信息
    NSString *stringValue = nil;
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;//获取扫描结果
    }
    
    //显示一个alert框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"公司宣传"
                                                    message:stringValue
                                                   delegate:self
                                          cancelButtonTitle:@"赞一个"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //销毁当前模态视图控制器
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
