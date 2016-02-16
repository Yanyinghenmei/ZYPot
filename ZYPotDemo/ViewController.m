//
//  ViewController.m
//  ZYPotDemo
//
//  Created by Daniel on 16/2/16.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+ZYPot.h"

#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 运行时封装模型
    NSDictionary *dataDic = @{
        @"address" : @"China",
        @"addtime" : @"1451900764",
        @"birth" : @"2016-01-01",
        @"blood_type" : @"B",
        @"constellation" : @"Capricorn",
        @"email" : @"******@qq.com",
        @"expire_time" : @"1735983720",
        @"height" : @"185",
        @"name" : @"Daniel",
        @"preferences" : @"1,2,3",
        @"sex" : @"male",
        @"simg" : @"/Public/upfile/2016-01-27/1453886093751.jpg",
        @"user_id" : @"14",
        @"weight" : @"69"
    };
    
    NSArray *dataArr = @[dataDic];
    
    NSArray *modelArr = [Model modelsWithArr:dataArr];
    
    Model *model = modelArr[0];
    
    NSLog(@"expire_time:%@", model.expire_time);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
