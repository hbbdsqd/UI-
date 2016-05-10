//
//  TouchIdUnlock.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>

/**
 用户是否 想使用touchID解锁，这个配置，保存在NSUserDefaults。
 */
#ifndef KEY_UserDefaults_isTouchIdEnabledOrNotByUser
#define KEY_UserDefaults_isTouchIdEnabledOrNotByUser @"KEY_UserDefaults_isTouchIdEnabledOrNotByUser"
#endif

#pragma mark - 类

/**
 指纹解锁
 */
@interface TouchIdUnlock : NSObject {
@private
    NSString* _appName; //应用程序名字
}
@property (nonatomic, retain) NSString* reasonThatExplainAuthentication; //解释校验指纹的原因
@property (nonatomic, retain) NSString* alertMessageToShowWhenUserDisableTouchID; //如果用户拒绝使用touchID解锁，则 显示提醒。

/**
 单例
 */
+ (instancetype)sharedInstance;

/**
 *  校验指纹(即，指纹解锁)
 *  canVerifyTouchID 返回YES，才能调用 startVerifyTouchID。
 *
 *  @param completionBlock 块，当校验手势密码成功之后，在主线程执行。
 */
- (void)startVerifyTouchID:(void (^)(void))completionBlock;

@end
