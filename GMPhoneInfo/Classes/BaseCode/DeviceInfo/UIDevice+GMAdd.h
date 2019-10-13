//
//  UIDevice+GMAdd.h
//  GMCategories
//
//  Created by 小飞鸟 on 2019/04/03.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (GMAdd)
/*获取系统版本*/
+ (double)systemVersion;
/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;
/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;
/// 是否越狱.
@property (nonatomic, readonly) BOOL isJailbroken;
/*UUID*/
@property(nonatomic,copy,readonly)NSString * UUID;
/*获取IDFA*/
@property(nonatomic,copy,readonly)NSString * IDFA;
/*获取MAC地址*/
@property(nonatomic,copy,readonly)NSString * MACAddress;
/*获取外网IP*/
@property(nonatomic,copy,readonly)NSString * outerIP;
/*获取屏幕分辨率*/
@property(nonatomic,assign,readonly)CGFloat  screenPix;
/*获取电量*/
@property(nonatomic,assign,readonly)CGFloat BatteryLevel;
/*获取屏幕亮度*/
@property(nonatomic,assign,readonly)CGFloat ScreenBrightness;
/*获取设备WiFi名字*/
@property(nonatomic,copy,readonly)NSString * WifiSSID;

@end

NS_ASSUME_NONNULL_END
