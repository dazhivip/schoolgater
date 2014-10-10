//
//  HttpRequest.m
//  Util
//
//  Created by Ryan on 14-5-25.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation HttpRequest
+ (HttpRequest *)defaultClient {
    //创建单利
    static dispatch_once_t pred;
    __strong static HttpRequest *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[HttpRequest alloc] init];
    });
    
    return sharedInstance;
}
#pragma mark
#pragma mark - 发送http请求
- (AFHTTPRequestOperation *)postWithURLString:(NSString *)url
                                 andParamBody:(NSData *)body
                                      success:(void(^)(NSInteger statusCode, id responseObject))successAction
                                      failure:(void(^)(NSInteger statusCode, id error))failureAction
{
   
    return [self HttpRequestWithUrlString:url
                                  Headers:nil
                                 HttpData:body
                          TimeoutInterval:30
                           RequestSuccess:^(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, id responseObject) {
                               // 请求成功
                               if (statusCode == 200) {
                                   // 返回结果不是json数据
                                   NSString * result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                   if ([result isEqualToString:@"true"]) {
                                       successAction(1, nil);
                                       return;
                                   }
                                   else if ([result isEqualToString:@"faulse"]) {
                                       failureAction(0, nil);
                                       return;
                                   }
                                   
                                   // 是json数据
                                   NSError * error = nil;
                                   // 将请求结果转化成对象类型， 回调
                                   id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                                   if (error) {
                                       failureAction(0, nil);
                                       return;
                                   }
                                   else {
                                       if ([object isKindOfClass:[NSArray class]]) {
                                           successAction(1, object);
                                           return;
                                       }
                                       
                                       if ([object valueForKey:@"result"] == nil) {
                                           successAction(1, object);
                                           return;
                                       }
                                       if ([[object valueForKey:@"result"] integerValue] != 1) {
                                           failureAction(1, [object valueForKey:@"falseReason"]);
                                       }
                                       else {
                                           successAction(1, object);
                                       }
                                   }
                               }
                               else {
                                   failureAction(0, responseObject);
                               }
                           } RequestFailure:^(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, NSError *error) {
                               failureAction(0, nil);
                           }];
}

- (AFHTTPRequestOperation *)HttpRequestWithUrlString:(NSString*)urlString
                           Headers:(NSDictionary*)headers
                          HttpData:(NSData*)data
                   TimeoutInterval:(NSTimeInterval)timeoutInterval
                    RequestSuccess:(void (^)(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, id responseObject))success
                    RequestFailure:(void (^)(NSDictionary *requestHeaderDic, NSDictionary *responseHeaderDic, NSInteger statusCode, NSError *error))failure
{
    if (self.queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        [self.queue setMaxConcurrentOperationCount:4];
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"currentUrl is %@",url);
    if (url == NULL) {
        NSLog(@"HTTPRequest parameter error: url is nil!!!");
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    for (NSString*key in headers.allKeys) {
        [request addValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    if (data) {
        [request setHTTPBody:data];
        [request setHTTPMethod:@"POST"];
    }
    else {
        [request setHTTPMethod:@"GET"];
    }
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if (self.queue) {
                success(operation.request.allHTTPHeaderFields, operation.response.allHeaderFields, operation.response.statusCode, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            if (self.queue){
                failure(operation.request.allHTTPHeaderFields, operation.response.allHeaderFields, operation.response.statusCode, error);
            }
        }
    }];
    [self.queue addOperation:requestOperation];
    
    return requestOperation;
}

- (NSInteger)getQueueCount
{
    return self.queue.operations.count;
}

- (void)setSuspended:(BOOL)bl
{
    [self.queue setSuspended:bl];
}

- (void)cancelRequest:(AFHTTPRequestOperation *)request
{
    if ([[self.queue operations] containsObject:request]) {
        [request cancel];
    }
}

- (void)cancelAllRequest
{
    for (AFHTTPRequestOperation * request in [self.queue operations]) {
        [request cancel];
    }
    
    [self.queue cancelAllOperations];
}

- (void)distoryAllRequest
{
    for (AFHTTPRequestOperation * request in [self.queue operations]) {
        [request cancel];
    }
    
    [self.queue cancelAllOperations];
    self.queue = nil;
}

@end
