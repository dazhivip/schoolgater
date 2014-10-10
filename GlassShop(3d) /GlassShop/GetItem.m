//
//  GetItem.m
//  GlassShop
//
//  Created by Sarnath RD on 14-3-4.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "GetItem.h"

@implementation GetItem
/**
 *	@brief	从字典提取TestPaperItem对象
 *
 *	@param 	dic 	要提取的字典
 *
 *	@return	提取的TestPaperItem对象
 */
+(GetItem *)getItemFromDic:(NSDictionary *)dic
{
    GetItem *item = [[GetItem alloc] init];
    item.Sname = [dic objectForKey:@"ship_name"];
    item.Snum = [dic objectForKey:@"order_id"];
    item.Sdate = [dic objectForKey:@"createtime"];
	item.Ssum = [dic objectForKey:@"total_amount"];
	item.Sstate = [dic objectForKey:@"status"];
    return item;
}
@end
