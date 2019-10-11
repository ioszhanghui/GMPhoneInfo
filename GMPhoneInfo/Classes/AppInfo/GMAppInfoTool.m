//
//  GMAppInfoTool.m
//  FBSnapshotTestCase
//
//  Created by 小飞鸟 on 2019/10/11.
//

#import "GMAppInfoTool.h"

#import <CoreLocation/CoreLocation.h>//引入Corelocation框架

#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
#import <Contacts/Contacts.h>
#endif

#import <AddressBook/AddressBook.h>

#import <Photos/PHPhotoLibrary.h>

#import <AVFoundation/AVFoundation.h>

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define TSLog(format, ...) printf("\nclass: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define NSLog(fmt, ...) do { } while(0);
#define TSLog(...);/** 防止控制台打印数据不全 */
#endif


@implementation GMAppInfoTool

+(NSString *)appVersion{
    return [[self appBundleInfo] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)appName{
    return [[self appBundleInfo] objectForKey:@"CFBundleDisplayName"];
}

+(NSString *)appBundleID{
    
    return [[self appBundleInfo] objectForKey:@"CFBundleIdentifier"];
}


+(NSString *)buildVersion{
    
    return [[self appBundleInfo]objectForKey:@"CFBundleVersion"];
}

+(NSDictionary*)appBundleInfo{
    return [[NSBundle mainBundle]infoDictionary];
}

+(BOOL)openLocation{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
   CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( status==kCLAuthorizationStatusAuthorizedAlways||status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    return NO;
}

+(BOOL)openNotification{
    
    __block BOOL allowed = NO;

    if (@available(iOS 10.0,*)) {
        dispatch_semaphore_t  semaphore =  dispatch_semaphore_create(0);
        [[UNUserNotificationCenter currentNotificationCenter]requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted&&!error) {
                allowed = YES;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }else{
        UIUserNotificationSettings *  notificationSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notificationSettings.types !=UIUserNotificationTypeNone) {
            allowed = YES;
        }
    }
    return allowed;
}

+(BOOL)openAddressBook{
    
    NSAssert([[self appBundleInfo] objectForKey:@"NSContactsUsageDescription"]!=nil, @"请在 Info.plist 添加NSContactsUsageDescription");
  __block  BOOL allowed = NO;
    if (@available(iOS 9.0,*)) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus==CNAuthorizationStatusAuthorized) {
            allowed = YES;
        }else if (authStatus==CNAuthorizationStatusNotDetermined){
            dispatch_semaphore_t   semaphore = dispatch_semaphore_create(0);
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                
                dispatch_semaphore_signal(semaphore);
                if (!error) {
                    allowed = YES;
                }
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }else{
#if __IPHONE_OX_VERSION_MAX_ALLOWED <90000
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status==kABAuthorizationStatusAuthorized) {
            allowed = YES;
        }
#endif
    }
    return allowed;
}

+(BOOL)openAlbum{
    
    NSAssert([[self appBundleInfo] objectForKey:@"NSPhotoLibraryUsageDescription"]!=nil, @"请在 Info.plist 添加NSPhotoLibraryUsageDescription");
    __block BOOL allowed = NO;
    dispatch_semaphore_t   semaphore = dispatch_semaphore_create(0);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_semaphore_signal(semaphore);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status==PHAuthorizationStatusAuthorized) {
                allowed = YES;
            }
        });
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return allowed;
}

+(BOOL)openMicrophone{
    
    NSAssert([[self appBundleInfo] objectForKey:@"NSMicrophoneUsageDescription"]!=nil, @"请在 Info.plist 添加NSMicrophoneUsageDescription");
    __block BOOL allowed = NO;
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status==AVAuthorizationStatusAuthorized) {
        allowed = YES;
    }
    return allowed;
}
@end
