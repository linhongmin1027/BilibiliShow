//
//  LMLaunchRealModel.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMLaunchRealModel.h"
#import "LMLaunchModel.h"
@implementation LMLaunchRealModel
-(instancetype)initWithModel:(LMLaunchModel *)model{
    self=[super init];
    if (!self) return nil;
    self.image=model.image;
    self.start_time=model.start_time;
    self.end_time = model.end_time;
    self.duration = model.duration;
    self.times = model.times;
    return self;

}
@end
