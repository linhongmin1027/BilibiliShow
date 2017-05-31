//
//  LHMNetworkManager.m
//  BilibiliShow
//
//  Created by iOSDev on 17/5/3.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LHMNetworkManager.h"
#import "UIImage+LMAdd.h"
#define baseUrl @"www.baidu.com"
@implementation LHMNetworkManager
+(instancetype)shareManager{
    static LHMNetworkManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });



    return manager;


}
#pragma mark  - 重写baseurl方法
-(instancetype)initWithBaseURL:(NSURL *)url{
    self=[super initWithBaseURL:url];
    if (self==nil) return nil;
    /**  设置请求超时时间  */
    self.requestSerializer.timeoutInterval=3;
    /**  设置相应的缓存策略 
     NSURLRequestUseProtocolCachePolicy 默认的缓存策略,如果缓存不存在则直接从服务器请求数据,如果缓存存在,则根据response中的cache-Control字段来判断下一步操作,如:cache-control为字段mustrevalidata,则询问服务器数据是否有更新,无更新的话直接返回缓存数据,若已更新数据,则请求服务器
     */
    self.requestSerializer.cachePolicy=NSURLRequestUseProtocolCachePolicy;
    /**  序列化处理  */
    self.requestSerializer=[AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    self.responseSerializer=response;
    /**  设置实体头  */
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /**  设置接受的类型  */
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"applicatin/json",@"text/json",@"text/javascript",@"text/html", nil]];
    return self;
}
#pragma mark  - GET
+(void)GET:(NSString *)urlString params:(id)params sucessBlock:(requestSucess)successBlock failBlock:(requestFailure)failBlock progress:(downloadProgress)progress{
    [[LHMNetworkManager shareManager] GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        
    }];




}
#pragma mark  - POST
+(void)POST:(NSString *)urlString params:(id)params sucessBlock:(requestSucess)successBlock failBlock:(requestFailure)failBlock progress:(downloadProgress)progress{
[[LHMNetworkManager shareManager] POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
     progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    successBlock(responseObject);
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failBlock(error);
    
}];
}

#pragma mark  - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations
                  withImageArray:(NSArray *)imageArray
                 withTargetWidth:(CGFloat)width
                   withUrlString:(NSString *)urlString
                withSuccessBlock:(requestSucess)successBlock
                   withFailBlock:(requestFailure)failBlock
              withUploadProgress:(uploadProgress)progress{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i=0;
        /**  出于性能考虑,将上传图片进行压缩  */
        for (UIImage *image in imageArray) {
            UIImage *resizedImage=[UIImage IMGCompressed:image targetWidth:width];
            NSData *imgData=UIImageJPEGRepresentation(resizedImage, 5);
            //拼接data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picfile%ld",(long)i] fileName:@"image.png" mimeType:@"image/jpeg"];
            i++;
            
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        
    }];



}
#pragma mark  - 取消所有的网络请求
/**  取消所有请求  */
+(void)cancelAllRequest{

    [[LHMNetworkManager shareManager].operationQueue cancelAllOperations];


}
/**  取消某一个url请求  */
+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string{
    NSError *error;
    /**  根据请求的类型 以及 请求的url创建一个NSMutableURLRequest ---通过url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求  */
    NSString *urlToPeCancel=[[[[LHMNetworkManager shareManager].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    for (NSOperation *operation in [LHMNetworkManager shareManager].operationQueue.operations) {
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            //请求的类型匹配
            BOOL hasMatchRequestType =[requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            //请求的url匹配
            BOOL hasMatchRequestUrlstring =[urlToPeCancel isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            /**   两项都匹配的话 取消该请求 */
            if (hasMatchRequestType && hasMatchRequestUrlstring) {
                [operation cancel];
            }
        }
    }
    


}
@end




















