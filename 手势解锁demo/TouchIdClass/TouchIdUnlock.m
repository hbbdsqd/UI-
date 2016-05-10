//
//  TouchIdUnlock.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "TouchIdUnlock.h"
#import <AudioToolbox/AudioToolbox.h>
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchIdUnlock

/**
 单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static TouchIdUnlock* sharedInstance;

    dispatch_once(&once, ^{

        sharedInstance = [[self alloc] init];

    });

    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        if (appName.length <= 0)
            appName = @"";

        _appName = [[NSString alloc] initWithString:appName];
    }
    return self;
}

/**
 iOS 操作系统：是否 能够使用touchID解锁
 */
- (BOOL)isTouchIdEnabledOrNotBySystem
{
#ifdef __IPHONE_8_0
    LAContext* myContext = [[[LAContext alloc] init] autorelease];
    NSError* authError = nil;

    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        /**
         可以验证指纹
         */
        return YES;
    }
    else {
        /**
         无法验证指纹
         */
        return NO;
    }
#else
    /**
     无法验证指纹
     */
    return NO;
#endif /* __IPHONE_8_0 */
}

#pragma mark - 公开方法 part 2

/**
 能否 进行校验指纹(即，指纹解锁)
 */
- (BOOL)canVerifyTouchID
{
#ifdef __IPHONE_8_0
    LAContext* myContext = [[[LAContext alloc] init] autorelease];
    NSError* authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {

        /**
             可以进行 验证指纹
             */
        return YES;
    }
    else {
        /**
         无法验证指纹
         */
        return NO;
    }
#else
    /**
     无法验证指纹
     */
    return NO;
#endif /* __IPHONE_8_0 */
}

/**
 *  校验指纹(即，指纹解锁)
 *
 *  @param completionBlock 块，当校验手势密码成功之后，在主线程执行。
 */
- (void)startVerifyTouchID:(void (^)(void))completionBlock
{
    NSString* myLocalizedReasonString = [NSString stringWithFormat:@"通过验证指纹解锁%@", _appName];
    if (_reasonThatExplainAuthentication.length) {
        myLocalizedReasonString = _reasonThatExplainAuthentication;
    }

#ifdef __IPHONE_8_0
    LAContext* myContext = [[[LAContext alloc] init] autorelease];
    NSError* authError = nil;

    // Hide "Enter Password" button
    myContext.localizedFallbackTitle = @"";

    if (![self isTouchIdEnabledOrNotBySystem]) {
        return;
    }

    // show the authentication UI
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        /**
         读取用户配置：用户是否 想使用touchID解锁
         */
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError* error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action

                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 成功
                                         */
                                        [self authenticatedSuccessfully:completionBlock];
                                    });
                                }
                                else {
                                    // User did not authenticate successfully, look at error and take appropriate action

                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 失败
                                         */
                                        [self authenticatedFailedWithError:error];
                                    });
                                }
                            }];
    }
    else {
        // Could not evaluate policy; look at authError and present an appropriate message to user

        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             无法校验指纹
             */
            [self evaluatePolicyFailedWithError:nil];
        });
    }

#endif /* __IPHONE_8_0 */
}

#pragma mark -

- (void)dealloc
{
    if (_reasonThatExplainAuthentication) {
        [_reasonThatExplainAuthentication release];
        _reasonThatExplainAuthentication = nil;
    }
    if (_alertMessageToShowWhenUserDisableTouchID) {
        [_alertMessageToShowWhenUserDisableTouchID release];
        _alertMessageToShowWhenUserDisableTouchID = nil;
    }

    [super dealloc];
}

#pragma mark - 私有方法
/**
 指纹校验 成功
 */
- (void)authenticatedSuccessfully:(void (^)(void))completionBlock
{
    NSLog(@"指纹校验 成功");

    if (completionBlock) {
        completionBlock();
    }
}

/**
 指纹校验 失败
 */
- (void)authenticatedFailedWithError:(NSError*)error
{
    NSLog(@"指纹校验 失败");

    NSLog(@"%@", error);
    if (error.code == -1) {
        /**
         震动
         */
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

/**
 无法校验指纹
 */
- (void)evaluatePolicyFailedWithError:(NSError*)error
{
    NSLog(@"无法校验指纹");
}

@end
