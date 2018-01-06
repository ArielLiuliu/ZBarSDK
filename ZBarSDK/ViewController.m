//
//  ViewController.m
//  ZBarSDK
//
//  Created by Mr Qian on 2017/3/24.
//  Copyright © 2017年 Mr Qian. All rights reserved.
//

#import "ViewController.h"
#import "YiDa_ZBarVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    YiDa_ZBarVC *zbarVC = [[YiDa_ZBarVC alloc] init];
    [self presentViewController:zbarVC animated:YES completion:^{
    
    }];
}

@end
