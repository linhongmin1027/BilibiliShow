//
//  LMLaunchRealModel.h
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import <Realm/Realm.h>
@class LMLaunchModel;
@interface LMLaunchRealModel : RLMObject
/** 启动页的结束时间戳 */
@property NSString *end_time;
/** 启动页的开始时间戳 */
@property NSString *start_time;
/** 启动页持续的时间 */
@property NSString *duration;
/** 启动页图片地址 */
@property NSString *image;
/** 启动页的出现次数 */
@property NSString *times;



-(instancetype)initWithModel:(LMLaunchModel *)model;
@end

RLM_ARRAY_TYPE(LMLaunchRealModel)
