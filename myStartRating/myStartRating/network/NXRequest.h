//
//  NXRequest.h
//  iOSMojave
//
//  Created by iOS on 2018/11/15.
//  Copyright © 2018 NX. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "NXRequestURL.h"

#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^NXRequestSuccessBlock)(NSDictionary *response);
//typedef void(^NXRequestFaileBlock)(NSError *error);
//
//typedef void(^NXRequestDownloadSuccessBlock)(NSString *downloadPath);
//typedef void(^NXRequestDownloadProgressBlock)(NSProgress *downloadProgress);
typedef void (^DonwLoadSuccessBlock)(NSURL *fileUrlPath ,NSURLResponse *response );
typedef void (^DownLoadfailBlock)(NSError *error ,NSInteger statusCode);
typedef void (^DowningProgress)(NSProgress *progress);

@interface NXRequest : NSObject

@property (nonatomic,strong) AFURLSessionManager *manager;
/**  下载历史记录 */
@property (nonatomic,strong) NSMutableDictionary *downLoadHistoryDictionary;
/**
 创建实例
 */
+ (NXRequest *)sharedRequest;

//- (AFHTTPSessionManager *)createSessionManagerDefault;



///请求方法
/**
 文件下载
 @param urlHost 下载地址
 @param progress 下载进度
 @param localUrl 本地存储路径,如果传nil，默认在Library/Caches下
 @param success 下载成功
 @param failure 下载失败
 @return downLoadTask
 */
- (NSURLSessionDownloadTask  *)AFDownLoadFileWithUrl:(NSString*)urlHost
                                            progress:(DowningProgress)progress
                                        fileLocalUrl:(NSURL *)localUrl
                                             success:(DonwLoadSuccessBlock)success
                                             failure:(DownLoadfailBlock)failure;

/** 停止所有的下载任务*/
- (void)stopAllDownLoadTasks;

//- (void)downloadRequestWithUrl:(NSString *)url downloadProgressBlock:(NXRequestDownloadProgressBlock)downloadProgressBlock downloadSuccessBlock:(NXRequestDownloadSuccessBlock)downloadSuccessBlock failureBlock:(NXRequestFaileBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
