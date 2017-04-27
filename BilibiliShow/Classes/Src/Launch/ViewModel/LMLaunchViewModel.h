//
//  LMLaunchViewModel.h
//  BilibiliShow
//
//  Created by iOSDev on 17/4/27.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMLaunchModel.h"
@interface LMLaunchViewModel : NSObject
/** 模型 **/
@property(nonatomic ,strong)LMLaunchModel *model;
@property(nonatomic,strong,readonly)RACCommand *requestCommand;

-(void)loadlaunchDataArrFromNetWork;
-(BOOL)conformNowtimestamp;
-(instancetype)initWithModel:(LMLaunchModel *)model;
@end
