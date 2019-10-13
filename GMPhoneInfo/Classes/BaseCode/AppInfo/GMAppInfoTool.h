//
//  GMAppInfoTool.h
//  FBSnapshotTestCase
//
//  Created by 小飞鸟 on 2019/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMAppInfoTool : NSObject

/*APP版本号*/
@property(nonatomic,class,readonly)NSString * appVersion;
/*App BundleID*/
@property(nonatomic,class,readonly)NSString * appBundleID;
/*APP名字*/
@property(nonatomic,class,readonly)NSString * appName;
/*build版本号*/
@property(nonatomic,class,readonly)NSString * buildVersion;
/*是否 打开了定位*/
@property(nonatomic,class,readonly)BOOL openLocation;
/*是否打开了 推送权限*/
@property(nonatomic,class,readonly)BOOL openNotification;
/*是否打开了 通讯录访问*/
@property(nonatomic,class,readonly)BOOL openAddressBook;
/*是否打开了 相册权限*/
@property(nonatomic,class,readonly)BOOL openAlbum;
/*是否打开了麦克风*/
@property(nonatomic,class,readonly)BOOL openMicrophone;

@end

NS_ASSUME_NONNULL_END
