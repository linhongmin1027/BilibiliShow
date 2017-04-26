//
//  LMThirdPartyManager.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMThirdPartyManager.h"

@implementation LMThirdPartyManager
#pragma mark --创建单例管理对象
+(instancetype)manager{
    static id _instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc]init];
    });
    return _instance;
}
-(void)setupThirdPartyConfigurationWithApplication:(UIApplication *)application didFinishedLaunchingWithOptions:(NSDictionary *)launchOptions{





}
@end
