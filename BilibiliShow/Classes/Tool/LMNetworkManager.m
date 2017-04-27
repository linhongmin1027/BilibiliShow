//
//  LMNetworkManager.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMNetworkManager.h"
#import <AFNetworking.h>
@implementation LMNetworkManager

+(void)GET:(NSString *)url
    params:(NSDictionary *)params
  progress:(void(^)(NSProgress * ))progress
    sucess:(void(^)(id ))sucess
   failure:(void(^)(NSError *))failure{
    //1.获取请求管理者
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)POST:(NSString *)url
     params:(NSDictionary *)params
   pregress:(void(^)(NSProgress *))progress
    success:(void(^)(id))success
    failure:(void(^)(NSError *))failure{
    // 1.获得请求管理者
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 创建POST请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

#pragma mark 监听网络
+(void)startMonitoring:(void(^)(NSUInteger NetworkState))networkStateBlock{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                if (networkStateBlock) {
                    networkStateBlock(NetworkStateUnknown);
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (networkStateBlock) {
                    networkStateBlock(NetworkStateNone);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (networkStateBlock) {
                    networkStateBlock(NetworkStateWWAN);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (networkStateBlock) {
                    networkStateBlock(NetworkStateWiFi);
                }
                break;
            default:
                break;
        }
    }];
}

+(void)stopMonitoring{
    [[AFNetworkReachabilityManager manager] stopMonitoring];
}
#pragma mark --获取当前网络状况
+(NetworkState)getCurrentNetworkState{
    NSArray *subViews = [[[LMApplication valueForKey:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NetworkState state=NetworkStateNone;
    for (id child in subViews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType =[[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    state=NetworkStateNone;
                    break;
                case 1: //2G网络
                    state=NetworkStateWWAN;
                    break;
                case 2:  //3G网络
                    state=NetworkStateWWAN;
                    break;
                case 3: //4G网络
                    state=NetworkStateWWAN;
                    break;
                case 5:
                    state=NetworkStateWiFi;
                    break;
                    
                default:
                    break;
            }
  
        }
    }
    return state;
}











@end
