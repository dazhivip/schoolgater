//
//  LogicManager.m
//  Logic
//
//  Created by Ryan on 14-5-25.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import "LogicManager.h"

@interface LogicManager ()
@property (nonatomic, strong) StarsMabager *starManager;

@end

@implementation LogicManager

+ (LogicManager *)getSingleton
{
    static LogicManager* m_singleton = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_singleton = [[LogicManager alloc] init];
    });
    return m_singleton;
}

- (id)init
{
    if (self = [super init]) {
		self.starManager = [StarsMabager shareInstance];
    }
    return self;
}

- (StarsMabager *)getStarsManager
{
	return self.starManager;
}
@end
