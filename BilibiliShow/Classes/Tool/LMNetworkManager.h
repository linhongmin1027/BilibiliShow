//
//  LMNetworkManager.h
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//对网络请求的再次封装:负责整个项目的网络请求

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger ,NetworkState) {
    NetworkStateNone , //没有网络
    NetworkStateWWAN , //移动网络
    NetworkStateWiFi ,   //wifi
    NetworkStateUnknown  //未知网络
};
@interface LMNetworkManager : NSObject
/**
 *  对GET请求的再次封装
 *
 *  @param url      请求接口
 *  @param params   请求参数
 *  @param progress 请求进度
 *  @param sucess   成功之后返回
 *  @param failure  失败之后返回
 */

+(void)GET:(NSString *)url
    params:(NSDictionary *)params
  progress:(void(^)(NSProgress *))progress
    sucess:(void(^)(id))sucess
   failure:(void(^)(NSError *))failure;


/**
 *  对POST请求的再次封装
 *
 *  @param url      请求接口
 *  @param params   请求参数
 *  @param progress 请求进度
 *  @param success   成功之后返回
 *  @param failure  失败之后返回
 */
+(void)POST:(NSString *)url
     params:(NSDictionary *)params
   pregress:(void(^)(NSProgress *))progress
    success:(void(^)(id))success
    failure:(void(^)(NSError *))failure;

/**
 * 获取当前网络状态
 * 返回值:当前网络状态
 */
+(NetworkState)getCurrentNetworkState;


/**
 *开启网络监控
 *
 *
 */
+(void)startMonitoring:(void(^)(NSUInteger NetworkState))networkStateBlock;

/**
 *停止网络监控
 *
 */
+(void)stopMonitoring;
@end
