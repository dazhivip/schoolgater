//
//  ManagerBase.m
//  Logic
//
//  Created by Ryan on 14-6-5.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import "ManagerBase.h"

@interface ManagerBase ()

@end

@implementation ManagerBase

+ (instancetype)shareInstance
{
    return nil;
}

#pragma mark
#pragma mark 初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        self.httpRequest = [[HttpRequest alloc] init];
		
    }
    return self;
}

@end
