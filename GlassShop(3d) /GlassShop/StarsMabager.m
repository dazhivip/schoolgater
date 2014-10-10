//
//  StarsMabager.m
//  GlassShop
//
//  Created by Sarnath RD on 14-9-30.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "StarsMabager.h"
@implementation StarsMabager

#pragma mark
#pragma mark 单例方法
+ (instancetype)shareInstance
{
    static StarsMabager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (AFHTTPRequestOperation *)getStarsFirstNamesuccess:(void(^)(id responseObject))success
                                             failure:(void(^)(id responseObject))failure
{
    return [self.httpRequest postWithURLString:kStarsFirstName andParamBody:nil
                                       success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getStarsNameWithFName:(NSString*)name
										  success:(void(^)(id responseObject))success
										failure:(void(^)(id responseObject))failure
{
	return [self.httpRequest postWithURLString:kStarName(name) andParamBody:nil
									   success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getGlassListWithPageNum:(int)page
											 titStr:(NSString*)str
											success:(void(^)(id responseObject))success
											failure:(void(^)(id responseObject))failure
{
	return [self.httpRequest postWithURLString:kGetGlassList(page, str) andParamBody:nil
									   success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getCategorySuccess:(void(^)(id responseObject))success
									   failure:(void(^)(id responseObject))failure
{
	return [self.httpRequest postWithURLString:kGetCategories
								  andParamBody:nil
									   success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getPhotolistWithKName:(NSString*)name
										  success:(void(^)(id responseObject))success
										  failure:(void(^)(id responseObject))failure
{
	return [self.httpRequest postWithURLString:kGetPhotoFlow(name) andParamBody:nil
									   success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getFaceAPIKEYsuccess:(void(^)(id responseObject))success
                                         failure:(void(^)(id responseObject))failure
{
    return [self.httpRequest postWithURLString:kGetFaceKEY andParamBody:nil
									   success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}

- (AFHTTPRequestOperation *)getShareContent:(void(^)(id responseObject))success
                                    failure:(void(^)(id responseObject))failure
{
    return [self.httpRequest postWithURLString:kGetShareContent andParamBody:nil
                                       success:^(NSInteger statusCode, id responseObject) {
                                           success(responseObject);
                                       } failure:^(NSInteger statusCode, NSError *error) {
                                           failure(nil);
                                       }];
}
@end
