//
//  NXFileTool.m
//  iOSMojave
//
//  Created by iOS on 2018/11/15.
//  Copyright © 2018 NX. All rights reserved.
//

#import "NXFileTool.h"
//#import "ZIPFoundation-Swift.h"
#import <SSZipArchive.h>
//#import <UnzipKit/UnzipKit.h>
//#import "Objective-Zip.h"
//#import "iOSMojave-Swift.h"
//#import "Utilities.h"
//#import "LoginVM.h"


@import Compression;
@implementation NXFileTool


//static int BUFFER_SIZE = 1024;

/**
 创建html文件的总路径文件：'html'
 */
+ (void)creatHtmlPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断是否存在html总文件夹，若不存在则创建
    if ([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
        return;
    } else {
        [fileManager createDirectoryAtPath:[NXFileTool getHtmlDirectryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 获取html总文件夹的路径
 */
+ (NSString *)getHtmlDirectryPath
{
    NSString *totlePath = @"html";
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *htmlDirectryPath = [documentPath stringByAppendingPathComponent:totlePath];
    NSLog(@"获取html总文件夹的路径====:%@",htmlDirectryPath);
    
    return htmlDirectryPath;
}

/**
 同时解压page common压缩包并移动到'html'中
 @param pageZipPath 下载的page压缩包路径
 @param commonZipPath 下载的common压缩包路径
 @param block 是否成功回调
 */
//+ (void)togetherProcessPageZipPath:(NSString *)pageZipPath commonZipPath:(NSString *)commonZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // 替换html文件夹中的所有文件
//    if ([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
//        if ([fileManager removeItemAtPath:[NXFileTool getHtmlDirectryPath] error:nil]) {
//            [NXFileTool creatHtmlPath];
//        }
//    }
//    if ([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]])
//    {
//        // 创建static文件夹路径，创建static文件夹
//        NSString *staticPath = [NSString stringWithFormat:@"%@/%@",[NXFileTool getHtmlDirectryPath],@"static"];
//        if (![fileManager fileExistsAtPath:staticPath]) {
//            [fileManager createDirectoryAtPath:staticPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        // 解压文件平台ZipPath
//        [SSZipArchive unzipFileAtPath:pageZipPath toDestination: staticPath overwrite:YES password:nil progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
//            if (succeeded) {
//                if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                    NSLog(@"删除原zip包失败");
//                }
//                // 再解压文件commonZipPath
//                [SSZipArchive unzipFileAtPath:commonZipPath toDestination:staticPath overwrite:YES password:nil progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
//                    if (succeeded) {
//                        block(YES);
//                        if (![fileManager removeItemAtPath: commonZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                    } else {
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                        if (![fileManager removeItemAtPath: commonZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                        block(NO);
//                    }
//                }];
//
//            } else if (error) {
//                if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                    NSLog(@"删除原zip包失败");
//                }
//                if (![fileManager removeItemAtPath: commonZipPath error: nil]) {
//                    NSLog(@"删除原zip包失败");
//                }
//                block(NO);
//            }
//        }];
//
//        //UnzipKit
//        NSError *archiveError = nil;
//        UZKArchive *archive = [[UZKArchive alloc] initWithPath:commonZipPath error:&archiveError];
//        NSError *error = nil;
//        BOOL extractFilesSuccessful = [archive extractFilesTo:staticPath overwrite:YES progress:^(UZKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
//            NSLog(@"percentArchiveDecompressed:%f", percentArchiveDecompressed);
//        } error:&error];
//        if (extractFilesSuccessful) {
//            block(YES);
//            if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                NSLog(@"删除原zip包失败");
//            }
//        } else {
//            block(NO);
//            if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                NSLog(@"删除原zip包失败");
//            }
//        }
//    }
//}

/**
 解压static压缩包
 @param pageZipPath 下载的static压缩包路径
 @param block 是否成功回调
 */
+ (void)processStaticZipPath:(NSString *)pageZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 替换html文件夹中的所有文件
    if ([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
        if ([fileManager removeItemAtPath:[NXFileTool getHtmlDirectryPath] error:nil]) {
            [NXFileTool creatHtmlPath];
        }
    } else {
        [NXFileTool creatHtmlPath];
    }
    
    if([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
        // 创建static文件夹路径，创建static文件夹
        NSString *staticPath = [NSString stringWithFormat:@"%@/%@",[NXFileTool getHtmlDirectryPath],@"static"];
        if (![fileManager fileExistsAtPath:staticPath]) {
            [fileManager createDirectoryAtPath:staticPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *chmodStr = @"";
        if ([fileManager fileExistsAtPath: staticPath]) {
            //修改文件权限
//            if (![fileManager isExecutableFileAtPath:staticPath] || ![fileManager isWritableFileAtPath:staticPath] || ![fileManager isReadableFileAtPath:staticPath]) {
                NSDictionary *attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:1000],NSFileModificationDate,[NSNumber numberWithInteger:0777],NSFilePosixPermissions,nil];
                NSError *err=nil;
                BOOL isset = [fileManager setAttributes:attr ofItemAtPath:staticPath error:&err];
                chmodStr = [NSString stringWithFormat:@"权限修改是否成功:%@,  权限修改报错:%@,  是否可读:%@,可写:%@,可执行:%@  ", isset ? @"是" :@"否", [err localizedDescription],[fileManager isReadableFileAtPath:staticPath] ? @"1" : @"0", [fileManager isWritableFileAtPath:staticPath] ? @"1" : @"0", [fileManager isExecutableFileAtPath:staticPath] ? @"1" : @"0"];
//            }

            if ([fileManager removeItemAtPath: staticPath error:nil]) {
                
                //ZIPFoundation（swift方法处理）
                
//                UnzipTool *unzipTool = [[UnzipTool alloc] init];
//
//                [unzipTool newUnzipFileFromPath:pageZipPath toPath:staticPath unzipResult:^(BOOL isSuccess, NSString * _Nonnull resultInfo) {
//                    NSString *info = [NSString stringWithFormat:@"%@, 解压信息:%@;  下载的文件:%@;  解压后的文件:%@,是否可读:%@,可写:%@,可执行:%@",chmodStr, resultInfo, pageZipPath ,staticPath, [fileManager isReadableFileAtPath:staticPath] ? @"可读" : @"不可读", [fileManager isWritableFileAtPath:staticPath] ? @"可写" : @"不可写", [fileManager isExecutableFileAtPath:staticPath] ? @"可执行" : @"不可执行"];
//                    if (isSuccess) {
//                        block(YES);
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                    } else {
//                        block(NO);
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                    }
//
//                    NSDictionary *dataDic = @{
//                        @"rank": @{},
//                        @"rank_detail": @"",
//                        @"client": @"ios-test",
//                        @"complain_detail":info ,
//                        @"complain_tag": @[],
//                        @"user_location": @"earth",
//                        @"platform": @"套壳测试",
//                        @"user_ip": @"test-ios",
//                        @"files": @[]
//                    };
//                    [self collectedDataWith:dataDic];
//                }];
//
                
                
                //SSZipArchive
                [SSZipArchive unzipFileAtPath: pageZipPath toDestination:staticPath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    NSLog(@"====staticPath====:%@", staticPath);
                    NSLog(@"====pageZipPath====:%@", pageZipPath);

//                    NSString *info = [NSString stringWithFormat:@"%@,   失败报错:%@;  下载的文件:%@;  解压后的文件:%@,是否可读:%@,可写:%@,可执行:%@",chmodStr, [error localizedDescription],pageZipPath ,staticPath, [fileManager isReadableFileAtPath:staticPath] ? @"可读" : @"不可读", [fileManager isWritableFileAtPath:staticPath] ? @"可写" : @"不可写", [fileManager isExecutableFileAtPath:staticPath] ? @"可执行" : @"不可执行"];
//                    NSDictionary *dataDic = @{
//                        @"rank": @{},
//                        @"rank_detail": @"",
//                        @"client": @"ios-test",
//                        @"complain_detail":info ,
//                        @"complain_tag": @[],
//                        @"user_location": @"earth",
//                        @"platform": @"套壳测试",
//                        @"user_ip": @"test-ios",
//                        @"files": @[]
//                    };
//                    [self collectedDataWith:dataDic];

                    if (succeeded) {
                        block(YES);
                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
                            NSLog(@"删除原zip包失败");
                        }
                    } else { // 没有解压成功，说明包有问题，删除该zip
                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
                            NSLog(@"删除原zip包失败");
                        }
                        block(NO);
                    }
                }];
                
                //native compression framwork
                NSData *theData = [NSData dataWithContentsOfFile: pageZipPath];
                size_t theDataSize = [theData length];
                const uint8_t *buf = (const uint8_t *)[theData bytes];
                uint8_t *destBuf = malloc(sizeof(uint8_t) * theDataSize);
                size_t compressedSize = compression_encode_buffer(destBuf, theDataSize, buf, theDataSize, NULL, COMPRESSION_LZFSE);
//                self.<NSData item> = [NSData dataWithBytes:destBuf length:compressedSize];

                NSLog(@"originalsize:%zu compressed:%zu", theDataSize, compressedSize);
                free(destBuf);
                
                //UnzipKit
//                NSError *archiveError = nil;
////                UZKArchive *archive = [UZKArchive zipArchiveAtPath:@"An Archive.zip" error:&archiveError];
//                UZKArchive *archive = [[UZKArchive alloc] initWithPath:pageZipPath error:&archiveError];
//                NSError *error = nil;
//                BOOL extractFilesSuccessful = [archive extractFilesTo:staticPath overwrite:YES progress:^(UZKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
//                    NSLog(@"percentArchiveDecompressed:%f", percentArchiveDecompressed);
//                } error:&error];
//
//                NSString *info = [NSString stringWithFormat:@"%@,  解压前读取文件:%@;  解压完成1:%@;  解压是否成功:%@。 ,是否可读:%@,可写:%@,可执行:%@",chmodStr, [archiveError localizedDescription],[error localizedDescription], extractFilesSuccessful ? @"成功了" : @"失败了", [fileManager isReadableFileAtPath:staticPath] ? @"可读" : @"不可读", [fileManager isWritableFileAtPath:staticPath] ? @"可写" : @"不可写", [fileManager isExecutableFileAtPath:staticPath] ? @"可执行" : @"不可执行"];
//                NSDictionary *dataDic = @{
//                    @"rank": @{},
//                    @"rank_detail": @"",
//                    @"client": @"ios-test",
//                    @"complain_detail":info ,
//                    @"complain_tag": @[],
//                    @"user_location": @"earth",
//                    @"platform": @"套壳测试",
//                    @"user_ip": @"test-ios",
//                    @"files": @[]
//                };
//                [self collectedDataWith:dataDic];
//                if (extractFilesSuccessful) {
//                    block(YES);
//                    if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                        NSLog(@"删除原zip包失败");
//                    }
//                } else {
//                    block(NO);
//                    if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                        NSLog(@"删除原zip包失败");
//                    }
//                }
                
                
                //OZZipFile
//                @try {
//                    OZZipFile *unzipFile = [[OZZipFile alloc] initWithFileName:pageZipPath mode:OZZipFileModeUnzip];
//                  //解压是否完成
//                    BOOL unzipFinished = NO;
//                    while (!unzipFinished) {
//                    //获取当前遍历到的文件信息
//                        OZFileInZipInfo *info = [unzipFile getCurrentFileInZipInfo];
//                        OZZipReadStream *stream = [unzipFile readCurrentFileInZip];
//                        NSMutableData *buffer = [[NSMutableData alloc] initWithLength:BUFFER_SIZE];
//
//                        // unzip files to the write path
//                        NSString *writePath = [staticPath stringByAppendingPathComponent:info.name];
//                        if ([info.name hasSuffix:@"/"]) {
//                        //创建目录
//                            NSFileManager *fileManager = [NSFileManager defaultManager];
//                            [fileManager createDirectoryAtPath:writePath withIntermediateDirectories:YES attributes:nil error:nil];
//        //                    [MFFileToolkit createDrectoryIfNeeded:writePath];
//                        }else{
//                        //创建文件
//                            NSFileManager *fileManager = [NSFileManager defaultManager];
//                            [fileManager createFileAtPath:writePath contents:nil attributes:nil];
//
//        //                    [MFFileToolkit createFilePath:writePath];
//
//                            //create fileHanderler to manage writing data to specified path, before writing data, move
//                            //the cusor to the end of the file first.
//                            NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:writePath];
//                            [buffer setLength:0];
//
//                            do {
//                                [buffer setLength:BUFFER_SIZE];
//                                NSInteger bytesRead = [stream readDataWithBuffer:buffer];
//
//                          //每次读取BUFFER_SIZE大小的数据，如果读出的数据大小>0，就继续循环读取数据，
//
//                          //直到读到的数据大小<= 0时，退出循环，当前遍历的文件已解压完毕
//                                if (bytesRead > 0) {
//                                    [buffer setLength:bytesRead];
//                                    [fileHandler seekToEndOfFile];
//                                    [fileHandler writeData:buffer];
//                                }else{
//                                    break;
//                                }
//                            } while (YES);
//
//                            [fileHandler closeFile];
//                        }
//
//                        [stream finishedReading];
//                        buffer = nil;
//
//                        // Check if we should continue reading
//                        unzipFinished = ![unzipFile goToNextFileInZip];
//                    }
//
//                    if (unzipFinished) {
//                        block(YES);
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
////                        NSString *info = [NSString stringWithFormat:@"%@, 解压是否成功:%@。 ,是否可读:%@,可写:%@,可执行:%@",chmodStr, unzipFinished ? @"成功了" : @"失败了", [fileManager isReadableFileAtPath:staticPath] ? @"可读" : @"不可读", [fileManager isWritableFileAtPath:staticPath] ? @"可写" : @"不可写", [fileManager isExecutableFileAtPath:staticPath] ? @"可执行" : @"不可执行"];
////                        NSDictionary *dataDic = @{
////                            @"rank": @{},
////                            @"rank_detail": @"",
////                            @"client": @"ios-test",
////                            @"complain_detail":info ,
////                            @"complain_tag": @[],
////                            @"user_location": @"earth",
////                            @"platform": @"套壳测试",
////                            @"user_ip": @"test-ios",
////                            @"files": @[]
////                        };
////                        [self collectedDataWith:dataDic];
//                    }
//                }
//                @catch (OZZipException *exception) {
//
////                    NSString *info = [NSString stringWithFormat:@"%@, 解压是否成功:%@。 ,是否可读:%@,可写:%@,可执行:%@",chmodStr, @"失败了", [fileManager isReadableFileAtPath:staticPath] ? @"可读" : @"不可读", [fileManager isWritableFileAtPath:staticPath] ? @"可写" : @"不可写", [fileManager isExecutableFileAtPath:staticPath] ? @"可执行" : @"不可执行"];
////                    NSDictionary *dataDic = @{
////                        @"rank": @{},
////                        @"rank_detail": @"",
////                        @"client": @"ios-test",
////                        @"complain_detail":info ,
////                        @"complain_tag": @[],
////                        @"user_location": @"earth",
////                        @"platform": @"套壳测试",
////                        @"user_ip": @"test-ios",
////                        @"files": @[]
////                    };
////                    [self collectedDataWith:dataDic];
//
//                    block(YES);
//                    if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                        NSLog(@"删除原zip包失败");
//                    }
//                    @throw exception;
//                }
                
            }
        }
    }
}

//统计
+(void)collectedDataWith:(NSDictionary *)data
{
//    [[[LoginVM alloc] init] sendFeedbackInfowithData:data uccess:^(id responseData) {
//        [[JTToast toastWithText:@"统计上传成功了" configuration:[JTToastConfiguration defaultConfiguration]]show];
//    } failed:^(id responseData) {
//    }];
}

/**
 单独处理page压缩包
 @param pageZipPath 下载的page压缩包路径
 @param block 是否成功回调
 */
//+ (void)separatelyProcessPageZipPath:(NSString *)pageZipPath platform:(NSString *)platform success:(void (^)(bool isSuccess))block
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    // 替换html文件夹中的所有文件
//    if ([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
//        if ([fileManager removeItemAtPath:[NXFileTool getHtmlDirectryPath] error:nil]) {
//            [NXFileTool creatHtmlPath];
//        }
//    }
//
//    if([fileManager fileExistsAtPath:[NXFileTool getHtmlDirectryPath]]) {
//        // 创建static文件夹路径，创建static文件夹
//        NSString *staticPath = [NSString stringWithFormat:@"%@/%@",[NXFileTool getHtmlDirectryPath],@"static"];
//        if (![fileManager fileExistsAtPath:staticPath]) {
//            [fileManager createDirectoryAtPath:staticPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//
//        if ([fileManager fileExistsAtPath: staticPath]) {
//            if ([fileManager removeItemAtPath: staticPath error:nil]) {
//                [SSZipArchive unzipFileAtPath: pageZipPath toDestination:staticPath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
//                    if (succeeded) {
//                        block(YES);
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                    } else { // 没有解压成功，说明包有问题，删除该zip
//                        if (![fileManager removeItemAtPath: pageZipPath error: nil]) {
//                            NSLog(@"删除原zip包失败");
//                        }
//                        block(NO);
//                    }
//                }];
//            }
//        }
//    }
//}

/**
 单独处理common压缩包
 @param commonZipPath 下载的common压缩包路径
 @param block 是否成功回调
 */
//+ (void)separatelyProcessCommonZipPath:(NSString *)commonZipPath success:(void (^)(bool isSuccess))block
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    NSString *staticPath = [NSString stringWithFormat:@"%@/%@",[NXFileTool getHtmlDirectryPath],@"static"];
//    NSString *commonPath = [NSString stringWithFormat:@"%@/%@",staticPath,@"common"];
//
//    if ([fileManager fileExistsAtPath:commonPath]) {
//        if ([fileManager removeItemAtPath:commonPath error:nil]) {
//            [SSZipArchive unzipFileAtPath:commonZipPath toDestination:staticPath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
//                if (succeeded) {
//                    block(YES);
//                    if (![fileManager removeItemAtPath: commonZipPath error: nil]) {
//                        NSLog(@"删除原zip包失败");
//                    }
//                } else {
//                    if (![fileManager removeItemAtPath: commonZipPath error: nil]) {
//                        NSLog(@"删除原zip包失败");
//                    }
//                    block(NO);
//                }
//            }];
//        }
//    }
//}



@end
