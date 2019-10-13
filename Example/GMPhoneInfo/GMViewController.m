//
//  GMViewController.m
//  GMPhoneInfo
//
//  Created by ioszhanghui@163.com on 10/10/2019.
//  Copyright (c) 2019 ioszhanghui@163.com. All rights reserved.
//

#import "GMViewController.h"
#import <GMPhoneInfo/GMPhoneInfo_Header.h>
//#import "UIDevice+GMAdd.h"
//
//#import "GMAppInfoTool.h"



@interface GMViewController ()

@end

@implementation GMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    assert(YES);
//    NSAssert(NO, @"条件信息");
    [self testAppInfo];
    
}

-(void)testDeviceInfo{
    
    NSLog(@"systemVersion%f",[UIDevice systemVersion]);
    NSLog(@"outerIP%@",[UIDevice currentDevice].outerIP);
    NSLog(@"isJailbroken%d",[UIDevice currentDevice].isJailbroken);
    NSLog(@"UUID%@",[UIDevice currentDevice].UUID);
    
    NSLog(@"IDFA%@",[UIDevice currentDevice].IDFA);
    NSLog(@"screenPix%f",[UIDevice currentDevice].screenPix);
    NSLog(@"screenPix%f",[UIDevice currentDevice].BatteryLevel);
    NSLog(@"ScreenBrightness%f",[UIDevice currentDevice].ScreenBrightness);
    NSLog(@"ScreenBrightness%@",[UIDevice currentDevice].WifiSSID);
}

-(void)testAppInfo{
    
    NSLog(@"appVersion***%@",[GMAppInfoTool appVersion]);
    NSLog(@"appBundleID***%@",[GMAppInfoTool appBundleID]);
    NSLog(@"appName***%@",[GMAppInfoTool appName]);
     NSLog(@"buildVersion***%@",[GMAppInfoTool buildVersion]);
    NSLog(@"openLocation***%d",[GMAppInfoTool openLocation]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"openNotification***%d",[GMAppInfoTool openNotification]);
    });
//    NSLog(@"openAddressBook***%d",[GMAppInfoTool openAddressBook]);
//    NSLog(@"openAlbum***%d",[GMAppInfoTool openAlbum]);
//    NSLog(@"openMicrophone***%d",[GMAppInfoTool openMicrophone]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
