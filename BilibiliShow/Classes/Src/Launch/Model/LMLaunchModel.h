//
//  LMLaunchModel.h
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMLaunchModel : NSObject
/** 启动页的结束时间戳 */
@property (nonatomic, copy) NSString *end_time;
/** 启动页的开始时间戳 */
@property (nonatomic, copy) NSString *start_time;
/** 启动页持续的时间 */
@property (nonatomic, copy) NSString *duration;
/** 启动页图片地址 */
@property (nonatomic, copy) NSString *image;
/** 启动页的出现次数 */
@property (nonatomic, copy) NSString *times;

@property (nonatomic, copy) NSString *animate;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *key;



/**
 * type =0 (广告(3秒读秒)带连接参数)
 * type =1 无参数活动预告
 */
@property(nonatomic,copy)NSString *type;

/**
 *  连接参数
 */
@property(nonatomic,copy) NSString *param;
@end
