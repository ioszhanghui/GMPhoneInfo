//
//  UIDevice+GMAdd.m
//  GMCategories
//
//  Created by 小飞鸟 on 2019/04/03.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "UIDevice+GMAdd.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation UIDevice (GMAdd)
/*获取系统版本*/
+ (double)systemVersion{
    return [[UIDevice currentDevice].systemVersion floatValue];
}
/*是不是IPad*/
-(BOOL)isPad{
    
    // return [[UIDevice currentDevice].localizedModel isEqualToString:@"iPad"];

    static dispatch_once_t onceToken;
    static BOOL _isPad= NO;
    dispatch_once(&onceToken, ^{
       _isPad = UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad;
    });
    
    return _isPad;
}
-(BOOL)isSimulator{
    #if TARGET_IPHONE_SIMULATOR  //模拟器
        return YES;
    #elif TARGET_OS_IPHONE      //真机
        return NO;
    #endif
}

-(NSString *)IDFA{
    static dispatch_once_t onceToken;
    static NSString * _IDFA = nil;
    dispatch_once(&onceToken, ^{
        _IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    });
    return _IDFA;
}


-(NSString *)MACAddress{
    
    static NSString * _MACAddress = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error/n");
            return ;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1/n");
            return ;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!/n");
            return ;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            return ;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        
        NSLog(@"outString:%@", outstring);
        
        free(buf);
        _MACAddress = [outstring uppercaseString];
    });
    return _MACAddress;
}


-(BOOL)isJailbroken{
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    //一般来说，手机越狱后会增加以下文件
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [self UUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

-(NSString*)UUID{
    
    static dispatch_once_t onceToken;
    static CFStringRef _string ;
    dispatch_once(&onceToken, ^{
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        _string = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    });
    return (__bridge_transfer NSString *)_string;
}

-(CGFloat)screenPix{
    
    static CGFloat _screenPix;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //屏幕尺寸
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        CGSize size = rect.size;
        
        CGFloat width = size.width;
        
        CGFloat height = size.height;
        
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        
        _screenPix = width*scale_screen*height*scale_screen;
    });
    return _screenPix;
}

//外网IP
-(NSString *)outerIP{
    
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (!data) {
        return nil;
    }
    
    NSDictionary * ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]; 
    NSString * ipStr = nil;
    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
        ipStr = ipDic[@"data"][@"ip"];
    }
    return (ipStr ? ipStr : @"");
}

//获取电量
-(CGFloat)BatteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [[UIDevice currentDevice] batteryLevel];
}
//获取屏幕亮度
-(CGFloat)ScreenBrightness{
    return [UIScreen mainScreen].brightness;
}

- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

//获取WiFi名字
-(NSString *)WifiSSID{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    return [dctySSID objectForKey:@"SSID"];
}

@end
