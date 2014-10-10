

//

#import "Util.h"

@implementation Util

/**
 *	@brief	当前登录用户的信息 为单例模式
 *
 *	@return	用户信息
 */
+(UserEntity * )getCurrentUserInfo
{
    static dispatch_once_t pred;
    static UserEntity *currentUser;
    dispatch_once(&pred, ^{
        currentUser = [[UserEntity alloc] init];
    });
    return currentUser;
}

/**
 *	@brief	返回字体,大小为size的字体
 *
 *	@param 	size 	尺寸
 *
 *	@return	格式
 */
+(UIFont *)getFont:(NSInteger)size
{
	return [UIFont fontWithName:@"Helvetica" size:size];
}

/**
 *	@brief	通过键值获取当前语言环境下的值
 *
 *	@param 	keyVar 	键
 *
 *	@return	国际化对应的值
 */
+(NSString *) getLocalized:(NSString *)keyVar
{
    return NSLocalizedString(keyVar, nil);
}


/**
 *	@brief	构造执行业务逻辑的等待框
 *
 *	@param 	view     弹出等待视图的父视图
 *	@param 	delegate HUD的协议的实现
 *	@param 	title 	 显示内容
 *	@param 	sel 	 执行方法
 *
 *	@return	加载框
 */
+(MBProgressHUD*) getExecuteHUD:(UIView*) view HUD:(id<MBProgressHUDDelegate>) dele
						  Title:(NSString*)title Sel:(SEL)sel{
	//可用
	//弹出等待信息
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	HUD.delegate = dele;
	HUD.labelText = [Util getLocalized:title];
	HUD.labelFont=[Util getFont:14];
	HUD.minSize = CGSizeMake(100.f, 100.f);
	[HUD showWhileExecuting:sel onTarget:dele withObject:nil animated:YES];
	return HUD;
}

@end
