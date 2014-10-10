//
//  GSUtil.m
//  GlassShop
//
//  Created by Sarnath RD on 14-2-25.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "GSUtil.h"
#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
CGFloat kTabbarHeight = 49.0f;
@implementation GSUtil


//创建文件夹//获取文件夹路径，不存在的话自动创建
+(NSString *)getDirectoryPath:(NSString*)dirName
{
	//文件管理器
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	
	//document目录
	NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	//要创建文件夹的完整目录
	NSString *dir = [doc stringByAppendingPathComponent:dirName];
	
	//是否存在
	BOOL isExist = YES;
	
	//判断是否存在
	if(!([fileManager fileExistsAtPath:dir isDirectory:&isExist]&&isExist))
	{
		NSError *error=nil;
		//如果不存在，就创建
		if([fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error]==NO)
		{
			NSLog(@"folder create is fail!");
            
			
		}
	}
    return dir;
}

//画面下方信息提示
+(void) toast:(NSString *)info ShowInView:(UIView *)view
{
	//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    if ([[GSUtil getLocalized:info] length]==0) {
        [view makeToast:info duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(150, 300)]];
    }else{
        [view makeToast:[GSUtil getLocalized:info] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(160, 300)]];
    }
}

////当前网络状态
//+(NetworkStatus)currentNetworkStatus
//{
//    NetworkStatus status = 0;
//    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus])
//    {
//			// 没有网络连接
//        case NotReachable:
//            status = NotReachable;
//            break;
//			// 使用3G/GPRS网络
//        case ReachableViaWWAN:
//            status = ReachableViaWWAN;
//            break;
//			// 使用WiFi网络
//        case ReachableViaWiFi:
//            status = ReachableViaWiFi;
//            break;
//    }
//    return status;
//}

//当前网络状态，可以区分2g还是3g
+ (NSString *)currentNetWorkStatusString
{
    NSString *netWorkStatus ;
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    NSNumber *dataNetworkItemView = nil;
    
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            
            dataNetworkItemView = subview;
            
            break;
            
        }
        
    }
    
    
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    
    if (num == nil) {
        
        NSLog(@"当前无网络1");
        netWorkStatus = nil;
        
        
    }else{
        
        int n = [num intValue];
        
        if (n == 0) {
            
            netWorkStatus = nil;
            NSLog(@"当前无网络2");
            
        }else if (n == 1){
            
            netWorkStatus = @"2G";
            NSLog(@"当前网络2G");
            
        }else if (n == 2){
            NSLog(@"当前网络3G");
            netWorkStatus = @"3G";
            
        }else{
            NSLog(@"当前网络Wifi");
            netWorkStatus = @"WiFi";
            
        }
        
    }
    return netWorkStatus;
    
}

/**
 * @discription 显示加载框MBProgressHUD
 * @param
 *      view - 要显示MBProgressHUD的视图
 *      text - 加载框上的提示信息
 *      mBProgressHUDDelegate - MBProgressHUD的委托对象
 * @return
 *      none
 */
+(void)addProgressHUBInView:(UIView *)view textInfo:(NSString *)text delegate:(id<MBProgressHUDDelegate>)mBProgressHUDDelegate
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD* progress = [[MBProgressHUD alloc] initWithWindow:keywindow];
//   [progress setMode:MBProgressHUDModeAnnularDeterminate];
    [keywindow addSubview:progress];
    [keywindow bringSubviewToFront:progress];
    progress.delegate = mBProgressHUDDelegate;
    progress.labelText = [[GSUtil getLocalized:text] length] ? [GSUtil getLocalized:text]:text;
    [progress show:YES];
}

/**
 * @discription 移除加载框MBProgressHUD
 * @param
 *      view - 要移除MBProgressHUD的视图
 * @return
 *      none
 */
+(void)removeProgressHUB:(UIView *)view
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:keywindow animated:NO];
}

/**
 * @discription 把float型时间转换成 yyyy-MM-dd HH:mm 格式
 * @param
 *      string - 要转换的float时间
 * @return
 *      转换后的时间
 */
+(NSString *)getmfDateFromDotNetJSONString:(NSString *)string
{
    NSString* dateAsString = string;
    dateAsString = [dateAsString stringByReplacingOccurrencesOfString:@"/Date("
                                                           withString:@""];
    dateAsString = [dateAsString stringByReplacingOccurrencesOfString:@"+0800)/"
                                                           withString:@""];
    
    unsigned long long milliseconds = [dateAsString longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* createTime = [formatter stringFromDate:date];
    
    return createTime;
}

/**
 *	@brief	让label自适应大小，并赋予字符串
 *
 *	@param 	label 	目标label
 *	@param 	string 	目标字符串
 *	@param 	maxRect 	label的原点和最大尺寸信息
 */
+(void)autoSizeLabel:(UILabel *)label withString:(NSString *)string setFrame:(CGRect )maxRect
{
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize maxSize = maxRect.size;
    
    //根据str计算label实际大小
    CGSize labelSize = [string sizeWithFont:label.font
						  constrainedToSize:maxSize
							  lineBreakMode:NSLineBreakByCharWrapping];
	//    NSLog(@"label高度:%.2f",labelSize.height);
    CGFloat aWidth = maxRect.size.width>labelSize.width ? maxRect.size.width : labelSize.width;
    [label setFrame:CGRectMake(maxRect.origin.x,maxRect.origin.y, aWidth, labelSize.height)];
    label.text = string;
}

/**
 *	@brief	给视图设置边线
 *
 *	@param 	view 	要设置边线的视图
 */
+(void)setBorderforView:(UIView *)view
{
    view.layer.borderColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1].CGColor;
    view.layer.borderWidth = 1;
}

//通过键值获取当前语言环境下的值
//参数keyVar 键
//返回 国际化对应的值
+(NSString *) getLocalized:(NSString *)keyVar
{
    return NSLocalizedString(keyVar, nil);
}

//根据路径返回文件的字符串
+(NSString *)getFilePath:(NSString*)fileName{
    //得到沙箱目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *docDir = [paths objectAtIndex:0];
    
	docDir =[docDir stringByAppendingString: @"/"];
    
    NSString *filePath =[docDir stringByAppendingString: fileName];
	
    return filePath;
}

/**
 *	@brief	压缩图片
 *
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/**
 *	@brief	隐藏tableview 多余的分割线，在tableview的数据源为空时可能不生效，可以在numberOfRowsInsection函数，通过判断dataSouce的数据个数，如果为零可以将tableview的separatorStyle设置为UITableViewCellSeparatorStyleNone去掉分割线，然后在大于零时将其设置为
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

////保存到沙盒
//+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str andImage:(NSData*)imgData
//{
//    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
//    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
//	NSString * imgK = [NSString stringWithFormat:@"img-%d-%d",type,_id];
//    [setting setObject:str forKey:key];
//	[setting setObject:imgData forKey:imgK];
//    [setting synchronize];
//}

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str
{
	NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
	NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
	[setting setObject:str forKey:key];
	[setting synchronize];
}
//判断沙盒是否有内容获取
+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
	
    NSString *value = [settings objectForKey:key];
    return value;
}
+(UIImage*)getImg:(int)type andID:(int)_id
{
	NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * imgK = [NSString stringWithFormat:@"img-%d-%d",type,_id];
	
	UIImage*img =[UIImage imageWithData:[settings objectForKey:imgK]];
    return img;
}

//创建文件夹
+(NSString *)createDirectory:(NSString*)dirName
{
	//文件管理器
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	
	//document目录
	NSString *doc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	
	//要创建文件夹的完整目录
	NSString *dir = [doc stringByAppendingPathComponent:dirName];
	
	//是否存在
	BOOL isExist = YES;
	
	//判断是否存在
	if(!([fileManager fileExistsAtPath:dir isDirectory:&isExist]&&isExist))
	{
		NSError *error=nil;
		//如果不存在，就创建
		if([fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error]==NO)
		{
			NSLog(@"folder create is fail!");
            
			
		}
	}
    return dir;
}

@end
