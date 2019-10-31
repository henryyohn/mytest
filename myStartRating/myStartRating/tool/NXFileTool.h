//
//  NXFileTool.h
//  iOSMojave
//
//  Created by iOS on 2018/11/15.
//  Copyright © 2018 NX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXFileTool : NSObject


/**
 创建html文件的总路径文件：'html'
 */
+ (void)creatHtmlPath;

/**
 获取html总文件夹的路径
 */
+ (NSString *)getHtmlDirectryPath;


/**
 同时解压page common压缩包并移动到'html'中
 
 @param pageZipPath 下载的page压缩包路径
 @param commonZipPath 下载的common压缩包路径
 @param platform 平台名
 @param block 是否成功回调
 */
+ (void)togetherProcessPageZipPath:(NSString *)pageZipPath commonZipPath:(NSString *)commonZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block;

/**
 解压static压缩包
 @param pageZipPath 下载的static压缩包路径
 @param block 是否成功回调
 */
+ (void)processStaticZipPath:(NSString *)pageZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block;

/**
 单独处理page压缩包

 @param pageZipPath 下载的page压缩包路径
 @param platform 平台名
 @param block 是否成功回调
 */
+ (void)separatelyProcessPageZipPath:(NSString *)pageZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block;

/**
 单独处理common压缩包
 
 @param commonZipPath 下载的common压缩包路径
 @param block 是否成功回调
 */
+ (void)separatelyProcessCommonZipPath:(NSString *)commonZipPath success:(void (^)(bool isSuccess))block;


@end

NS_ASSUME_NONNULL_END
