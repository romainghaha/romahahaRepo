//
//  UploadImageManager.h
//  04-上传多个文件
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFileManager : NSObject

+ (instancetype)sharedManager;

/**
 *  单文件上传的主方法,不附带文本信息
 *
 *  @param URLString      文件上传的地址
 *  @param serverFileName 服务器接收文件的字段名
 *  @param filePath      文件路径的数组
 *  @param completion      回调
 */
- (void)uploadFileWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePath:(NSString *)filePath completion:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completion;


/**
 *  单文件上传的主方法,附带文本信息
 *
 *  @param URLString      文件上传的地址
 *  @param serverFileName 服务器接收文件的字段名
 *  @param filePath      文件路径的数组
 *  @param textDict       文件上传的附带信息
 */
- (void)uploadFileWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePath:(NSString *)filePath textDict:(NSDictionary *)textDict completion:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completion;

/**
 *  多文件上传的主方法,不附带文本信息
 *
 *  @param URLString      文件上传的地址
 *  @param serverFileName 服务器接收文件的字段名
 *  @param filePaths      文件路径的数组
 */
- (void)uploadFilesWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePaths:(NSArray *)filePaths completion:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completion;

/**
 *  多文件上传的主方法,附带文本信息
 *
 *  @param URLString      文件上传的地址
 *  @param serverFileName 服务器接收文件的字段名
 *  @param filePaths      文件路径的数组
 *  @param textDict       文件上传的附带信息
 */
- (void)uploadFilesWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePaths:(NSArray *)filePaths textDict:(NSDictionary *)textDict completion:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completion;


@end
