//
//  LHMNetworkManager.h
//  BilibiliShow
//
//  Created by iOSDev on 17/5/3.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**  成功  */
typedef void(^requestSucess) (id object);
/**  失败  */
typedef void(^requestFailure) (NSError *error);
/**  上传进度 */
typedef void(^uploadProgress)(float progress);
/**  下载进度  */
typedef void(^downloadProgress)(float progress);


@interface LHMNetworkManager : AFHTTPSessionManager

@end
