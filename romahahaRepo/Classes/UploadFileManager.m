//
//  UploadImageManager.m
//  04-上传多个文件
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "UploadFileManager.h"

@implementation UploadFileManager

+ (instancetype)sharedManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)uploadFileWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePath:(NSString *)filePath completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    [self uploadFilesWithURLString:URLString serverFileName:serverFileName filePaths:@[filePath] textDict:nil completion:completion];
}

- (void)uploadFileWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePath:(NSString *)filePath textDict:(NSDictionary *)textDict completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    [self uploadFilesWithURLString:URLString serverFileName:serverFileName filePaths:@[filePath] textDict:textDict completion:completion];
}

- (void)uploadFilesWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePaths:(NSArray *)filePaths completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    [self uploadFilesWithURLString:URLString serverFileName:serverFileName filePaths:filePaths textDict:nil completion:completion];
}

- (void)uploadFilesWithURLString:(NSString *)URLString serverFileName:(NSString *)serverFileName filePaths:(NSArray *)filePaths textDict:(NSDictionary *)textDict completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion{
    
    NSURL *URL = [NSURL URLWithString: URLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    // 设置请求方式为POST
    request.HTTPMethod = @"POST";
    // 设置请求头
    [request setValue:@"multipart/form-data; boundary=itheima" forHTTPHeaderField:@"Content-Type"];
    // 设置请求体
    request.HTTPBody = [self getHTTPBodyWithServerName:serverFileName filePaths:filePaths textDict:textDict];
    
    // 发起请求
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: completion] resume];
}

/**
 获取请求体
 
 @param serverName 服务器设定的参数名
 @param filePaths 路径
 @param textDict 要上传的文字参数
 @return 请求体
 */
- (NSData *)getHTTPBodyWithServerName:(NSString *)serverName filePaths:(NSArray<NSString *> *)filePaths textDict:(NSDictionary *)textDict{
    // 先初始化一个空的二进制数据
    NSMutableData *dataM = [[NSMutableData alloc] init];
    // 循环拼接
    [filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull fileURLString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableString *strM = [[NSMutableString alloc] init];
        // 拼接开始的分割符
        [strM appendString:@"--itheima\r\n"];
        // 拼接相关参数
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", serverName, [fileURLString lastPathComponent]];
        // 拼接要上传的文件的类型
        [strM appendString:@"Content-Type: application/octet-stream\r\n"];
        // 拼接一个单独的换行
        [strM appendString:@"\r\n"];
        // 将前半部分的字符串转成二进制数据拼接到最终结果里面
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 拼接二进制数据
        NSURL *fileURL = [NSURL fileURLWithPath:fileURLString];
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        [dataM appendData:fileData];
        
        // 拼接一个换行
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 拼接文本参数
    [textDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString *strM = [[NSMutableString alloc] init];
        // 拼接开始的分割符
        [strM appendString:@"--itheima\r\n"];
        // 拼接相关参数
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        // 拼接一个单独的换行
        [strM appendString:@"\r\n"];
        // 拼接参数的值
        [strM appendFormat:@"%@", obj];
        // 拼接换行
        [strM appendString:@"\r\n"];
        // 将文字的信息添加到结果的二进制数据中
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 拼接换行和结束的分割符
    [dataM appendData:[@"--itheima--" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [dataM copy];
}

@end
