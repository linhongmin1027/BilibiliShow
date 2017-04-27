#import <Masonry.h>
#import <MJExtension.h>
#import <ReactiveObjC.h>
#import <YYKit.h>

#import "LMNetworkManager.h"





#if DEBUG
#define LMLog(FORMAT,...) fprintf(stderr, "%s:%d行 %s \n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])



#else

#define LMLog(FORMAT, ...) nil


#endif


#define LMNotificationCenter [NSNotificationCenter defaultCenter]
#define LMUserDefaults [NSUserDefaults standardUserDefaults]
#define LMApplication [UIApplication sharedApplication]
#define LMFileManager [NSFileManager defaultManager]
#define LMDevice [UIDevice currentDevice]



/**
 *  颜色
 */
#define LMBlackColor [UIColor blackColor]
#define LMBlueColor [UIColor blueColor]
#define LMRedColor [UIColor redColor]
#define LMWhiteColor [UIColor whiteColor]
#define LMGrayColor [UIColor grayColor]
#define LMDarkGrayColor [UIColor darkGrayColor]
#define LMLightGrayColor [UIColor lightGrayColor]
#define LMGreenColor [UIColor greenColor]
#define LMCyanColor [UIColor cyanColor]
#define LMYellowColor [UIColor yellowColor]
#define LMMagentaColor [UIColor magentaColor]
#define LMOrangeColor [UIColor orangeColor]
#define LMPurpleColor [UIColor purpleColor]
#define LMBrownColor [UIColor brownColor]
#define LMClearColor [UIColor clearColor]


/** RGB颜色 */
#define LMColor_RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define LMColor_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define LMColor_RGBA_256(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0]
/** 随机色 */
#define LMRandomColor_RGB YPColor_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define LMRandomColor_RGBA YPColor_RGBA_256(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/** 弧度制转为角度制 */
#define LMAngle2Radian(angle) ((angle) / 180.0 * M_PI)




/** 系统状态栏高度 */
UIKIT_EXTERN CGFloat const kAppStatusBarHeight;
/** 系统导航栏高度 */
UIKIT_EXTERN CGFloat const kAppNavigationBarHeight;
/** 系统tabbar高度 */
UIKIT_EXTERN CGFloat const kAppTabBarHeight;

/** 系统间距字段 8 */
UIKIT_EXTERN CGFloat const kAppPadding_8;
/** 系统间距字段 12 */
UIKIT_EXTERN CGFloat const kAppPadding_12;
/** 系统间距字段 16 */
UIKIT_EXTERN CGFloat const kAppPadding_16;
/** 系统间距字段 20 */
UIKIT_EXTERN CGFloat const kAppPadding_20;
/** 系统间距字段 24 */
UIKIT_EXTERN CGFloat const kAppPadding_24;
/** 系统间距字段 28 */
UIKIT_EXTERN CGFloat const kAppPadding_28;
/** 系统间距字段 32 */
UIKIT_EXTERN CGFloat const kAppPadding_32;

/** 屏幕比例适配 以iPhone6位基准*/
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/375
#define kHeight(R) (iPhone4?((R)*(kScreenHeight)/480):((R)*(kScreenHeight)/667))
#define font(R) (R)*(kScreenWidth)/375
/**************************尺寸****************************/

#define kDevice_Is_iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



//********************** Application常用字段Start *************************//
/** App启动次数 */
#define kAppLaunchTimes @"kAppLaunchTimes"

/** App的Appstore访问地址 */
UIKIT_EXTERN NSString * const kAppITunesURL;

/** tabBar被选中的通知 */
UIKIT_EXTERN NSString * const LMTabBarDidSelectNotification;
//********************** Application常用字段End ***************************//






