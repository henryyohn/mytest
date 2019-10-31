//
//  NXRequest.m
//  iOSMojave
//
//  Created by iOS on 2018/11/15.
//  Copyright © 2018 NX. All rights reserved.
//

#import "NXRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface NXRequest()

@property (nonatomic,strong) NSString  *fileHistoryPath;

@end

@implementation NXRequest

+ (NXRequest *)sharedRequest
{
    static NXRequest *NXRequestSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        NXRequestSingleton = [[self alloc] init];
    });
    return NXRequestSingleton;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.NXWorld.marketingdepartA.backgroundSession"];
        configuration.HTTPMaximumConnectionsPerHost = 2;
        //允许在蜂窝网络情况下继续请求下载
        configuration.allowsCellularAccess = YES;
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDownloadTask *task;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadData:) name:AFNetworkingTaskDidCompleteNotification object:task];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        self.fileHistoryPath=[path stringByAppendingPathComponent:@"fileDownLoadHistory.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileHistoryPath]) {
            self.downLoadHistoryDictionary =[NSMutableDictionary dictionaryWithContentsOfFile:self.fileHistoryPath];
        }else{
            self.downLoadHistoryDictionary =[NSMutableDictionary dictionary];
            //将dictionary中的数据写入plist文件中
            [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
        }
        NSLog(@"%s   self.test.session = %@ ",__func__,self.manager.session);
    }
    return  self;
}

// 记录下载历史的方式，后面为断点续传使用
- (void)saveHistoryWithKey:(NSString *)key DownloadTaskResumeData:(NSData *)data{
    if (!data) {
        NSString *emptyData = [NSString stringWithFormat:@""];
        [self.downLoadHistoryDictionary setObject:emptyData forKey:key];
    }else{
        [self.downLoadHistoryDictionary setObject:data forKey:key];
    }
    
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:NO];
}

- (void)saveDownLoadHistoryDirectory{
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
}

#pragma mark - 下载方法
- (NSURLSessionDownloadTask *)AFDownLoadFileWithUrl:(NSString*)urlHost
                                           progress:(DowningProgress)progress
                                       fileLocalUrl:(NSURL *)localUrl
                                            success:(DonwLoadSuccessBlock)success
                                            failure:(DownLoadfailBlock)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHost]];
    NSURLSessionDownloadTask   *downloadTask = nil;
    NSData *downLoadHistoryData = [self.downLoadHistoryDictionary   objectForKey:urlHost];
//NSLog(@"本地是否存储需要续传的数据长度为 %ld",downLoadHistoryData.length);
    NSLog(@"进入下载任务了=============================");
//    if (downLoadHistoryData.length > 0 ) {//暂不支持断点续传
    if (NO) {
        NSLog(@"使用旧任务");
        downloadTask = [self.manager downloadTaskWithResumeData:downLoadHistoryData progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                //                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                progress(downloadProgress);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return localUrl;
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                    //将下载失败存储起来  提交到下面的 的网络监管类里面
                }
            }else{
                if (success) {
                    success(filePath,response);
                }
                //将下载成功存储起来  提交到下面的 的网络监管类里面
            }
            
        }];
    }else{
        //NSLog(@"开辟 新任务");
        downloadTask = [self.manager  downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
//                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                progress(downloadProgress);
//                NSLog(@"==000=%F",(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount));
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (localUrl) {
                return localUrl;
            } else {
                NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
                return [NSURL fileURLWithPath:path];
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"完成");
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
                //将下载失败存储起来  提交到了appDelegate 的网络监管类里面
            }else{
                if (success) {
                    success(filePath,response);
                }
                //将下载成功存储起来  提交到了appDelegate 的网络监管类里面
            }
            
        }];
    }
    [downloadTask resume];
    return downloadTask;
}

// ==============下载处理的关键代码===============
-(void) downloadData: (NSNotification *) notification {
    if ([notification.object isKindOfClass:[NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *task = notification.object;
        NSString *urlHost = [task.currentRequest.URL absoluteString];
        NSError *error  = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey] ;
        if (error) {
            if (error.code == -1001) {
                NSLog(@"下载出错,看一下网络是否正常");
            }
            NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            [self saveHistoryWithKey:urlHost DownloadTaskResumeData:resumeData];
            NSLog(@"下载出错了，查看当前URL：%@", urlHost);
            //这个是因为 用户比如强退程序之后 ,再次进来的时候 存进去这个继续的data  需要用户去刷新列表
        }else{
            NSLog(@"下载没有出错，查看当前URL：%@", urlHost);
            if ([self.downLoadHistoryDictionary valueForKey:urlHost]) {
                [self.downLoadHistoryDictionary removeObjectForKey:urlHost];
                [self saveDownLoadHistoryDirectory];
                NSLog(@"[self.downLoadHistoryDictionary valueForKey:urlHost]为true===============：%@", [self.downLoadHistoryDictionary valueForKey:urlHost]);
            }
        }
    }
}
// 暂时不用
- (void)stopAllDownLoadTasks{
    //停止所有的下载
    if ([[self.manager downloadTasks] count]  == 0) {
        return;
    }
    for (NSURLSessionDownloadTask *task in  [self.manager downloadTasks]) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                
            }];
        }
    }
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
