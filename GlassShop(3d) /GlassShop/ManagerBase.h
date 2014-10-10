//
//  ManagerBase.h
//  Logic
//
//  Created by Ryan on 14-6-5.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@interface ManagerBase : NSObject

// 模块的HTTP请求
@property (nonatomic, strong) HttpRequest * httpRequest;

// 获取单例
+ (instancetype)shareInstance;

@end
