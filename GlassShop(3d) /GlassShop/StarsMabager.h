//
//  StarsMabager.h
//  GlassShop
//
//  Created by Sarnath RD on 14-9-30.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "ManagerBase.h"
#import "ILogicModelBase.h"
@interface StarsMabager : ManagerBase
//明星首字母
- (AFHTTPRequestOperation *)getStarsFirstNamesuccess:(void(^)(id responseObject))success
                                             failure:(void(^)(id responseObject))failure;

//明星名字
- (AFHTTPRequestOperation *)getStarsNameWithFName:(NSString*)name
										  success:(void(^)(id responseObject))success
										  failure:(void(^)(id responseObject))failure;

//获取眼镜列表
- (AFHTTPRequestOperation *)getGlassListWithPageNum:(int)page
											 titStr:(NSString*)str
											success:(void(^)(id responseObject))success
											failure:(void(^)(id responseObject))failure;


//眼镜分类
- (AFHTTPRequestOperation *)getCategorySuccess:(void(^)(id responseObject))success
                                             failure:(void(^)(id responseObject))failure;


//图片列表
- (AFHTTPRequestOperation *)getPhotolistWithKName:(NSString*)name
										  success:(void(^)(id responseObject))success
										  failure:(void(^)(id responseObject))failure;

//获取face++APIKEY
- (AFHTTPRequestOperation *)getFaceAPIKEYsuccess:(void(^)(id responseObject))success
										  failure:(void(^)(id responseObject))failure;
//分享内容
- (AFHTTPRequestOperation *)getShareContent:(void(^)(id responseObject))success
                                         failure:(void(^)(id responseObject))failure;
@end
