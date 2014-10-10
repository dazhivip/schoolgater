//
//  GetItem.h
//  GlassShop
//
//  Created by Sarnath RD on 14-3-4.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetItem : NSObject
@property(strong,nonatomic) NSString *Sname;

@property(strong,nonatomic) NSString *Snum;

@property(strong,nonatomic) NSString *Sdate;

@property(strong,nonatomic) NSString *Ssum;

@property(strong,nonatomic) NSString *Sstate;

/**
 *	@brief	从字典提取TestPaperItem对象
 *
 *	@param 	dic 	要提取的字典
 *
 *	@return	提取的TestPaperItem对象
 */
+(GetItem *)getItemFromDic:(NSDictionary *)dic;
@end
