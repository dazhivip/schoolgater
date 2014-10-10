//
//  GSUtil.h
//  GlassShop
//
//  Created by Sarnath RD on 14-2-25.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"
extern CGFloat kTabbarHeight;
@interface GSUtil : NSObject

/**
 * @description 获取文件夹路径，不存在的话自动创建， ！此方法只针对Document下的目录
 * @param
 *     dirName - 目录名称
 * @return
 *     目录的路径
 */
+(NSString *)getDirectoryPath:(NSString*)dirName;

/**
 * @description 弹出提示信息
 * @param
 *      info - 弹出的提示文字
 *      view - 在那个视图上弹出
 * @return
 *
 */
+(void) toast:(NSString *)info ShowInView:(UIView *)view;



//当前网络状态，可以区分2g还是3g
+ (NSString *)currentNetWorkStatusString;

/**
 * @discription 显示加载框
 * @param
 *      view - 要显示MBProgressHUD的视图
 *      text - 加载框上的提示信息
 *      mBProgressHUDDelegate - MBProgressHUD的委托对象
 * @return
 *      none
 */
+(void)addProgressHUBInView:(UIView *)view textInfo:(NSString *)text delegate:(id<MBProgressHUDDelegate>)mBProgressHUDDelegate;

/**
 * @discription 移除加载框MBProgressHUD
 * @param
 *      view - 要移除MBProgressHUD的视图
 * @return
 *      none
 */
+(void)removeProgressHUB:(UIView *)view;

/**
 * @discription 把float型时间转换成 yyyy-MM-dd HH:mm 格式
 * @param
 *      string - 要转换的float时间
 * @return
 *      转换后的时间
 */
+(NSString *)getmfDateFromDotNetJSONString:(NSString *)string;

/**
 *	@brief	让label自适应大小，并赋予字符串
 *
 *	@param 	label 	目标label
 *	@param 	string 	目标字符串
 *	@param 	maxRect 	label的原点和最大尺寸信息
 */
+(void)autoSizeLabel:(UILabel *)label withString:(NSString *)string setFrame:(CGRect )maxRect;

/**
 *	@brief	给视图设置边线
 *
 *	@param 	view 	要设置边线的视图
 */
+(void)setBorderforView:(UIView *)view;

/**
 * @description 返回文件字符串！此方法只针对Document下的目录
 * @param
 *     fileName - 文件名称
 * @return
 *     文件字符串
 */
+(NSString *)getFilePath:(NSString*)fileName;

/**
 *	@brief	压缩图片
 *
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *	@brief	隐藏tableview 多余的分割线，在tableview的数据源为空时可能不生效，可以在numberOfRowsInsection函数，通过判断dataSouce的数据个数，如果为零可以将tableview的separatorStyle设置为UITableViewCellSeparatorStyleNone去掉分割线，然后在大于零时将其设置为
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
////保存到沙盒
//+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str andImage:(NSData*)imgData;

//判断沙盒是否有内容获取
+ (NSString *)getCache:(int)type andID:(int)_id;
+(UIImage*)getImg:(int)type andID:(int)_id;
//缓存图片
+(NSString *)createDirectory:(NSString*)dirName;
@end
