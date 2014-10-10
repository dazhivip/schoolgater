//
//  HttpRequest.h
//  Util
//
//  Created by Ryan on 14-5-25.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void(^successBlock)(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, id responseObject);
typedef void(^failureBlock)(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, NSError *error);

@interface HttpRequest : NSObject

+ (HttpRequest *)defaultClient;

/**
 *  @brief 发起HTTP请求
 *
 *  @param url           请求地址
 *  @param body          post方式时的body，如果该参数为空为Get方式请求，非空为Post方式请求
 *  @param successAction 成功回调  statusCode:网络请求返回码        responseObject: 返回数据
 *  @param failureAction 失败回调  statusCode:网络请求返回码        error: 返回错误描述
 *
 *  @return 返回当前发起的HTTP请求，用于对当前请求暂停和取消等操作
 */
- (AFHTTPRequestOperation *)postWithURLString:(NSString *)url
                                 andParamBody:(NSData *)body
                                      success:(void(^)(NSInteger statusCode, id responseObject))successAction
                                      failure:(void(^)(NSInteger statusCode, id error))failureAction;

/**
*  @brief 发起一个HTTP请求
*
*  @param urlString       设置HTTP请求地址
*  @param headers         设置HTTP的head
*  @param data            设置HTTP的post方式的body，如果该参数为空为Get方式请求，非空为Post方式请求
*  @param timeoutInterval 设置HTTP请求超时时间
*  @param success         请求成功回调 requestHeaderDic: 请求头信息    responseHeaderDic: 响应头信息
                                     statusCode:网络请求返回码        responseObject: 返回数据
*  @param failure         请求失败回调 requestHeaderDic: 请求头信息    responseHeaderDic: 响应头信息 
                                     statusCode:网络请求返回码        error: 返回错误描述
*
*  @return 返回当前发起的HTTP请求，用于对当前请求暂停和取消等操作
*/
- (AFHTTPRequestOperation *)HttpRequestWithUrlString:(NSString*)urlString
                                             Headers:(NSDictionary*)headers
                                            HttpData:(NSData*)data
                                     TimeoutInterval:(NSTimeInterval)timeoutInterval
                                      RequestSuccess:(successBlock)success
                                      RequestFailure:(failureBlock)failure;

/**
 *  @brief  获取当前请求剩余队列个数
 *
 *  @return 队列个数
 */
- (NSInteger)getQueueCount;

/**
 *  @brief  设置当前线程是否中断
 *
 *  @param bl   是否中断
 *
 *  @return N/A
 */
- (void)setSuspended:(BOOL)bl;

/**
 *  @brief  取消某一个HTTP请求
 *
 *  @param request 待取消的请求
 */
- (void)cancelRequest:(AFHTTPRequestOperation *)request;

/**
 *  @brief  取消当前未完成请求队列
 *
 *  @return N/A
 */
- (void)cancelAllRequest;

/**
 *  @brief  销毁当前未完成请求队列
 *
 *  @return N/A
 */
- (void)distoryAllRequest;

@end
