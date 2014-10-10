
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

#import "MBProgressHUD.h"


@interface Util : NSObject

/**
 *	@brief	获取当前的用户信息
 *
 *	@return	用户信息
 */
+(UserEntity * )getCurrentUserInfo;
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
+(MBProgressHUD*) getExecuteHUD:(UIView*) view HUD:(id<MBProgressHUDDelegate>) delegate
						  Title:(NSString*)title Sel:(SEL)sel;

@end
