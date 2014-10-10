//
//  LogicManager.h
//  Logic
//
//  Created by Ryan on 14-5-25.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILogicModelBase.h"
#import "StarsMabager.h"

// 获取 LogicManager单例 宏定义
#define logicShareInstance   [LogicManager getSingleton]

/**
 *	@brief	逻辑管理对象, 通过逻辑管理对象可以获取各个业务模块接口
 */
@interface LogicManager : NSObject

//用来判别不再提醒
@property (nonatomic) BOOL noNote;

@property (nonatomic) int chos;
/**
 *	@brief	获取逻辑管理对象单例
 */
+ (LogicManager *)getSingleton;


/**
 *  @brief  获取明星管理对象单例
 */
- (StarsMabager *)getStarsManager;


@end
