//
//  LMThirdPartyManager.h
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMThirdPartyManager : NSObject
+(instancetype)manager;
-(void)setupThirdPartyConfigurationWithApplication:(UIApplication *)application didFinishedLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
