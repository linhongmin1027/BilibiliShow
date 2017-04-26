//
//  LMLaunchModel.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMLaunchModel.h"

@implementation LMLaunchModel
#if 0
+(NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{@"idStr" : @"id"};

}

#endif
+(NSDictionary *)modelCustomPropertyMapper{

    return @{@"idStr" : @"id"};
}
@end
