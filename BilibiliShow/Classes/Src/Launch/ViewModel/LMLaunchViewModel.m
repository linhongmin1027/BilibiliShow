//
//  LMLaunchViewModel.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/27.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMLaunchViewModel.h"

@implementation LMLaunchViewModel
-(instancetype)initWithModel:(LMLaunchModel *)model{
    self=[super init];
    if (!self) return nil;
    self.model=model;
    return self;
}
-(BOOL)conformNowtimestamp{
    long long timestamp= (long long) [[NSDate date] timeIntervalSince1970];
    if (timestamp > [self.model.start_time longLongValue] &&
        timestamp < [self.model.end_time longLongValue]) {
        return YES;
    }
    return NO;
}
-(void)loadlaunchDataArrFromNetWork{
    _requestCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal=[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
            [parameters setObject:@"3360" forKey:@"build"];
            [parameters setObject:@"appstore" forKey:@"chananel"];
            [parameters setObject:@"1" forKey:@"plat"];
            [parameters setObject:[@((int)kScreenWidth * 2) stringValue] forKey:@"width"];
            [parameters setObject:[@((int)kScreenHeight * 2) stringValue] forKey:@"height"];
            [LMNetworkManager GET:kSplashURL params:parameters progress:^(NSProgress *progress) {
                
            } sucess:^(id responseObject) {
                //程序的入口 开启计数器
                NSString *appOpenTimesStr=[LMUserDefaults objectForKey:kAppLaunchTimes];
                if (![appOpenTimesStr isNotBlank]) {//如果开启次数字段没有值
                    NSInteger appOpenTimes=1;
                    [LMUserDefaults setValue:[NSString stringWithFormat:@"%ld",appOpenTimes] forKey:kAppLaunchTimes];
                    
                }
                NSArray *modelArray =[NSArray modelArrayWithClass:[LMLaunchModel class] json:responseObject[@"data"]];
                [subscriber sendNext:modelArray];
                
            
                
                
                
            } failure:^(NSError *error) {
                
            }];
            return nil;
            
        }];
        return signal;
        
    }];
    
    





}

@end
