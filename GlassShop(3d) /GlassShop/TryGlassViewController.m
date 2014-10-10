//
//  TryGlassViewController.m
//  GlassShop
//
//  Created by Sarnath RD on 14-7-9.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "TryGlassViewController.h"
#import "MyHostViewController.h"
#import "UINavigationController+NewBackButton.h"
#import "FaceppLocalDetector.h"
#import "FaceppDetection+LocalResultUploader.h"
#import "FaceppAPI.h"
#import "GSUtil.h"

#import "TryGlassViewController+TopBarMessage.h"
#import "SmallGlassEntity.h"
#import "Util.h"
#import "UserEntity.h"
#import "ImageGetPixelColor.h"



//#import "UIImage+Rotate_Flip.h"
#define kTRYWIDTH ([UIScreen mainScreen].bounds.size.width)
#define kTRYHEIGHT 280
@interface TryGlassViewController ()
{
	CGFloat faceWidth;
	CGFloat trangle;
	UIImage *runIMg;
	CGPoint startPoint;
	NSInteger moveTag;//当前移动的视图的tag
	CGFloat Dx ;
	CGFloat Dy ;
	
	NSMutableArray *firstCenterArr;
    
    NSMutableArray *faceWArr;
    
    NSMutableArray *trangArr;
    //左边镜腿宽加角存储数组
    NSMutableArray *leftWArr;
    NSMutableArray *leftAngleArr;
     //右边镜腿宽加角存储数组
    NSMutableArray *rightWArr;
    NSMutableArray *rightAngleArr;
    //存储耳朵点
    NSMutableArray *earLArr;
    NSMutableArray *earRArr;
    
    //存储镜片4点

	
    NSMutableArray *newupleftArr;
    NSMutableArray *newuprightArr;
	BOOL haShiBie;
	
	SmallGlassEntity *entity;
}
@end

@implementation TryGlassViewController
@synthesize glass,gLeg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view from its nib.
    [self initHoustView];
	[self setupImgView];
	[self initboolInfo];
    [self getNewPhoto];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: NO];
	self.navigationController.navigationBarHidden = NO;
	
}

//重置或初始化信息
- (void)initboolInfo
{
	moveTag = 152;
	self.tryImgView.tag = 151;
	haShiBie = NO;
}

//配置imgView
- (void)setupImgView
{
	if (!IS_IOS7) {
		self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
	}
	//设置选照片button
    UIButton *titLB = [UIButton buttonWithType:UIButtonTypeCustom];
	titLB.frame = CGRectMake(0, 2, 100, 42);
    titLB.backgroundColor = [UIColor clearColor];  //设置Label背景透明
	
	[titLB setTitle:@"选照片" forState:UIControlStateNormal];
	[titLB setTitleColor:[UIColor colorWithRed:17/255.0 green:121/255.0 blue:247/255.0 alpha:0.9] forState:0];
	[titLB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    titLB.titleLabel.textAlignment = 1;
    titLB.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:17];
	
    self.navigationItem.titleView = titLB;
	
	[titLB addTarget:self action:@selector(getNewPhoto) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void) initHoustView
{
    self.navigationItem.leftBarButtonItems = [self.navigationController getNewBackButtons];

	MyHostViewController *vc = [MyHostViewController new];
	//由GlassTable传递过来的代理
	vc.MIdDelegate = self;
    vc.listArr = _hostArr;
	if (IS_IOS7) {
		vc.view.frame = CGRectMake(0,kLISTY, kSCREENWIDTH, kLISTHEIGHT);
	}else{
		vc.view.frame = CGRectMake(0,kLISTY-64, kSCREENWIDTH, kLISTHEIGHT);
	}
	[self.view addSubview:vc.view];
}


- (void)getNewPhoto
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Photo Album", nil), nil];
	
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Camera", nil)];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
	
}

#pragma mark - 以下是人脸识别部分内容
#pragma mark -
/**
 *  代理方法传值
 *
 *  @param price 价格
 *  @param name  型号
 *  @param gID   详情ID
 */
- (void)showDetail:(NSString*)price andxing:(NSString*)name forId:(NSString*)gID andUrl:(NSString*)url
{
	NSString*str = [price substringWithRange:NSMakeRange(0, [price length]-2)];
	NSString * detail = [NSString stringWithFormat:@"编号：%@   含镜片     ",name];
    
	self.nowID = gID;
    self.detailViewURl = url;
	[self showTopMessage:detail AndTit:str];
}
- (void)startPeiDai:(NSString*)name
{
	_imgName = name;
	
	
//	//对镜腿图片像素取点,适配镜腿高度
//	CGPoint legUp = [ImageGetPixelColor getPixelPointInImageLeft:legImg andSize:legImg.size];
//	CGPoint legLow = [ImageGetPixelColor getPixelPointInImageLowLeft:legImg andSize:legImg.size];
//	CGFloat legScanl = legImg.size.height/(legLow.y-legUp.y);

	if (haShiBie) {
		[GSUtil addProgressHUBInView:self.view textInfo:nil delegate:self];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			//获取镜片
			UIImage *glassImg = [self getImg];
			//获取镜腿
			UIImage *legImg = [self getGlassTui];

			dispatch_async(dispatch_get_main_queue(), ^{
                if (glassImg) {
                    if (moveTag==152) {
                        //所有脸一起换图片
                        for (UIView*img in [_tryImgView subviews]) {
                            if ([img isKindOfClass:[UIImageView class]]&&legImg) {
                                //镜片
                                if (img.tag<1000) {
                                    UIImageView *glaViews = (UIImageView*)img;
                                    //取值转换
                                    NSNumber*wedth = faceWArr[glaViews.tag];
                                    faceWidth = [wedth floatValue];
                                    NSNumber*tran = trangArr[glaViews.tag];
                                    trangle = [tran floatValue];
                                    CGPoint newCenter = CGPointFromString(firstCenterArr[glaViews.tag]);
                                    
                                    
                                    
                                    //换图片适配比例
                                    glaViews.transform=CGAffineTransformMakeRotation(0);
                                    CGFloat scanl = glassImg.size.height/glassImg.size.width;//比例
                                
                                    CGRect frame = glaViews.frame;
                                    frame.size.width = faceWidth;
                                    frame.size.height = faceWidth*scanl;
                                    glaViews.frame = frame;
                                    
                                    //2014.9.19修改为本地检测
                                    
                                    CGSize glaSize = glaViews.frame.size;
                                    //左上
                                    CGFloat upleftX=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].x+glaViews.frame.origin.x;
                                    CGFloat upleftY=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].y+glaViews.frame.origin.y;
                                    //右上
                                    CGFloat uprightX=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].x+glaViews.frame.origin.x;
                                    CGFloat upRightY=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].y+glaViews.frame.origin.y;
                                    //左下
                                    CGFloat downLeftX=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].x+glaViews.frame.origin.x;
                                    CGFloat downLeftY=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].y+glaViews.frame.origin.y;
                                    //右下
                                    CGFloat downRightX=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].x+glaViews.frame.origin.x;
                                    CGFloat downRightY=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].y+glaViews.frame.origin.y;
                                
                                    glaViews.transform=CGAffineTransformMakeRotation(trangle);
                                    
                                    glaViews.image = glassImg;
                                    
                                    //旋转后***坐标原点转换
                                    CGFloat newOupleftX = cos(trangle)*(upleftX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
                                    CGFloat newOupleftY = cos(trangle)*(upleftY-newCenter.y)+sin(trangle)*(upleftX-newCenter.x)+newCenter.y;
                                    
                                    CGFloat newOuprightX = cos(trangle)*(uprightX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
                                    CGFloat newOuprightY = cos(trangle)*(upRightY-newCenter.y)+sin(trangle)*(uprightX-newCenter.x)+newCenter.y;
                                    
                            
                                    CGFloat newOdownleftY=  cos(trangle)*(downLeftY-newCenter.y)+sin(trangle)*(downLeftX-newCenter.x)+newCenter.y;
                                    
                                    CGFloat newOdownrightY = cos(trangle)*(downRightY-newCenter.y)+sin(trangle)*(downRightX-newCenter.x)+newCenter.y;
									
									//传出距眼镜原点差值用于移动时使用
									//左镜腿用
									[newupleftArr replaceObjectAtIndex:img.tag withObject:NSStringFromCGPoint(CGPointMake(newOupleftX-img.frame.origin.x, newOupleftY-img.frame.origin.y))];
									//右镜腿用
									[newuprightArr replaceObjectAtIndex:img.tag withObject:NSStringFromCGPoint(CGPointMake(newOuprightX-img.frame.origin.x, newOuprightY-img.frame.origin.y))];
                             
                                    //左镜腿*************
                                    UIImageView *legViewL = (UIImageView*)[_tryImgView viewWithTag:img.tag+1000];
                                    if (legViewL) {
                                        //取值转换
                                        //                                    NSNumber*wedthL = leftWArr[legViewL.tag-1000];
                                        //
                                        //                                    NSNumber*tranL = leftAngleArr[legViewL.tag-1000];
                                        
                                        CGPoint earLeft = CGPointFromString(earLArr[legViewL.tag-1000]);
                                        
                                        //换图片适配比例
                                        legViewL.transform=CGAffineTransformMakeRotation(0);
                                        //先计算镜腿的长宽
                                        legViewL.frame = CGRectMake(0, 0, sqrt(pow((newOupleftY-earLeft.y), 2)+pow((newOupleftX-earLeft.x), 2)), newOdownleftY-newOupleftY);
                                        
                                        //移动到中心点然后再旋转
                                        
                                        //此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
                                        CGPoint leftCenter = CGPointMake((newOupleftX+earLeft.x)/2, (newOupleftY+earLeft.y)/2+(newOdownleftY-newOupleftY)/2);
                                        legViewL.center = leftCenter;
                                        
                                        /**
                                         *  旋转,旋转要在最后做，否则image属性改变对应坐标也改变
                                         */
                                        CGFloat legAngleL = atan((newOupleftY-earLeft.y)/(newOupleftX-earLeft.x));
										legViewL.transform=CGAffineTransformMakeRotation(legAngleL);
                                        
										//左侧翻转镜腿图片
										UIImage *flipLegImg = [UIImage imageWithCGImage:legImg.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
                                        legViewL.image = flipLegImg;

                                    }
                                    
                            
                                    //右镜腿*************
                                    UIImageView *legViewR = (UIImageView*)[_tryImgView viewWithTag:img.tag+10000];
                                    if (legViewR) {
                                        //取值转换
                                        //                                    NSNumber*wedthR = rightWArr[legViewR.tag-10000];
                                        //
                                        //                                    NSNumber*tranR = rightAngleArr[legViewR.tag-10000];
                                        CGPoint earRight = CGPointFromString(earRArr[legViewR.tag-10000]);
                                        //换图片适配比例
                                        legViewR.transform=CGAffineTransformMakeRotation(0);
                                        //安坐标适配镜腿大小
                                        CGRect frameR = legViewR.frame;
                                        frameR.size.width = sqrt(pow((earRight.y-newOuprightY), 2)+pow((earRight.x-newOuprightX), 2));
                                        frameR.size.height = newOdownrightY-newOuprightY;
                                        legViewR.frame = frameR;
                                        
                                        
                                        //移动到中心点然后再旋转
                                        
                                        //此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
                                        CGPoint rightCenter = CGPointMake((newOuprightX+earRight.x)/2, (newOuprightY+earRight.y)/2+(newOdownrightY-newOuprightY)/2);
                                        legViewR.center = rightCenter;
                                        
                                        /**
                                         *  旋转
                                         */
                                        CGFloat legAngleR = atan((earRight.y-newOuprightY)/(earRight.x-newOuprightX));
                                        
                                        legViewR.transform=CGAffineTransformMakeRotation(legAngleR);
                                        
                                        legViewR.image = legImg;

                                    }
                            }
                             
                        }
                        }
                    }else{
                        
                        //指定脸换图片,镜片
                        UIView *view=[self.tryImgView viewWithTag:moveTag];
                        UIImageView*moveGlass = (UIImageView*)view;
                        NSNumber*wedth = faceWArr[moveGlass.tag];
                        faceWidth = [wedth floatValue];
                        NSNumber*tran = trangArr[moveGlass.tag];
                        trangle = [tran floatValue];
                        
                        CGPoint newCenter = CGPointFromString(firstCenterArr[view.tag]);
                        //换图片适配比例
                        moveGlass.transform=CGAffineTransformMakeRotation(0);
                        CGFloat scanl = glassImg.size.height/glassImg.size.width;//比例
                        CGPoint center = moveGlass.center;
                        moveGlass.frame = CGRectMake(0, 0, faceWidth, faceWidth*scanl);
                        moveGlass.center = center;
                        //2014.9.19修改为本地检测
                        
                        CGSize glaSize = view.frame.size;
                        //左上
                        CGFloat upleftX=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].x+view.frame.origin.x;
                        CGFloat upleftY=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].y+view.frame.origin.y;
                        //右上
                        CGFloat uprightX=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].x+view.frame.origin.x;
                        CGFloat upRightY=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].y+view.frame.origin.y;
                        //左下
                        CGFloat downLeftX=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].x+view.frame.origin.x;
                        CGFloat downLeftY=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].y+view.frame.origin.y;
                        //右下
                        CGFloat downRightX=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].x+view.frame.origin.x;
                        CGFloat downRightY=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].y+view.frame.origin.y;
                        
                        moveGlass.transform=CGAffineTransformMakeRotation(trangle);
                        moveGlass.image = glassImg;
                        
                        //旋转后***坐标原点转换
                        CGFloat newOupleftX = cos(trangle)*(upleftX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
                        CGFloat newOupleftY = cos(trangle)*(upleftY-newCenter.y)+sin(trangle)*(upleftX-newCenter.x)+newCenter.y;
                        
                        CGFloat newOuprightX = cos(trangle)*(uprightX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
                        CGFloat newOuprightY = cos(trangle)*(upRightY-newCenter.y)+sin(trangle)*(uprightX-newCenter.x)+newCenter.y;
                        
                      
                        CGFloat newOdownleftY=  cos(trangle)*(downLeftY-newCenter.y)+sin(trangle)*(downLeftX-newCenter.x)+newCenter.y;
                        
                 
                        CGFloat newOdownrightY = cos(trangle)*(downRightY-newCenter.y)+sin(trangle)*(downRightX-newCenter.x)+newCenter.y;
						
						//传出距眼镜原点差值用于移动时使用
						//左镜腿用
						[newupleftArr replaceObjectAtIndex:moveTag withObject:NSStringFromCGPoint(CGPointMake(newOupleftX-view.frame.origin.x, newOupleftY-view.frame.origin.y))];
						//右镜腿用
						[newuprightArr replaceObjectAtIndex:moveTag withObject:NSStringFromCGPoint(CGPointMake(newOuprightX-view.frame.origin.x, newOuprightY-view.frame.origin.y))];
                        
                        //左镜腿
                        UIImageView *leftLegView = (UIImageView*)[self.tryImgView viewWithTag:moveTag+1000];

                        if (leftLegView&&legImg) {//防止后台无图片返回情况崩溃
                            
                            CGPoint earLeft = CGPointFromString(earLArr[leftLegView.tag-1000]);
                            
                            //换图片适配比例
                            leftLegView.transform=CGAffineTransformMakeRotation(0);
                            //先计算镜腿的长宽
                            leftLegView.frame = CGRectMake(0, 0, sqrt(pow((newOupleftY-earLeft.y), 2)+pow((newOupleftX-earLeft.x), 2)), newOdownleftY-newOupleftY);
                            
                            //移动到中心点然后再旋转
                            
                            //此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
                            CGPoint leftCenter = CGPointMake((newOupleftX+earLeft.x)/2, (newOupleftY+earLeft.y)/2+(newOdownleftY-newOupleftY)/2);
                            leftLegView.center = leftCenter;
                            
                            /**
                             *  旋转,旋转要在最后做，否则image属性改变对应坐标也改变
                             */
                            CGFloat legAngleL = atan((newOupleftY-earLeft.y)/abs((newOupleftX-earLeft.x)));
                            leftLegView.transform=CGAffineTransformMakeRotation(legAngleL);
                            
							//左侧翻转镜腿图片
							UIImage *flipLegImg = [UIImage imageWithCGImage:legImg.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
                            leftLegView.image = flipLegImg;

                        }
                        
                        
                        //右镜腿
                        UIImageView *rightLegView = (UIImageView*)[self.tryImgView viewWithTag:moveTag+10000];
                        if (rightLegView&&legImg) {
                            
                            CGPoint earRight = CGPointFromString(earRArr[rightLegView.tag-10000]);
                            //换图片适配比例
                            rightLegView.transform=CGAffineTransformMakeRotation(0);
                            //安坐标适配镜腿大小
                            CGRect frameR = rightLegView.frame;
                            frameR.size.width = sqrt(pow((earRight.y-newOuprightY), 2)+pow((earRight.x-newOuprightX), 2));
                            frameR.size.height = newOdownrightY-newOuprightY;
                            rightLegView.frame = frameR;
                            
                            
                            //移动到中心点然后再旋转
                            
                            //此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
                            CGPoint rightCenter = CGPointMake((newOuprightX+earRight.x)/2, (newOuprightY+earRight.y)/2+(newOdownrightY-newOuprightY)/2);
                            rightLegView.center = rightCenter;
                            
                            /**
                             *  旋转
                             */
                            CGFloat legAngleR = atan((earRight.y-newOuprightY)/abs((earRight.x-newOuprightX)));
                            
                            rightLegView.transform=CGAffineTransformMakeRotation(legAngleR);
                            
                            rightLegView.image = legImg;


                        }
                        
                    }

                }
								[GSUtil removeProgressHUB:self.view];
				
			});
		});
		
	}else{
        
		
		[GSUtil addProgressHUBInView:self.view textInfo:@"人脸识别中" delegate:self];
		
		
		
		if (IS_IPHONE_5) {
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 568), YES, 0);
		}else
		{
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 480), YES, 0);
		}
		
		[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		CGImageRef imageRef = viewImage.CGImage;
		CGRect rect;
		if (IS_IOS7) {
			rect =CGRectMake(0, 128, 640, 560);//这里可以设置想要截图的区域
		}else
		{
			rect =CGRectMake(0, 0, 640, 560);//这里可以设置想要截图的区域
		}
		
		
		CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
		UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			//获取镜片
			UIImage *glassImg = [self getImg];
			//获取镜腿
			UIImage *legImg = [self getGlassTui];

			
			NSDictionary *options = [NSDictionary dictionaryWithObjects:[
																		 NSArray arrayWithObjects:[NSNumber numberWithBool:YES],
																		 [NSNumber numberWithInt:20],
																		 FaceppDetectorAccuracyHigh, nil]
																forKeys:[
																		 NSArray arrayWithObjects:FaceppDetectorTracking,
																		 FaceppDetectorMinFaceSize,
																		 FaceppDetectorAccuracy, nil]];
			
			//face++方法从随机key中获取key
            FaceppLocalDetector *detector = [
											 FaceppLocalDetector detectorOfOptions: options andAPIKey:((UserEntity*)[Util getCurrentUserInfo]).faceAPIKey];
			
			
			//检测，并获取检测结果：
			
			FaceppLocalResult *result = [detector detectWithImage:sendImage];
			NSLog(@"count = %d", result.faces.count);
			for (size_t i=0; i < result.faces.count; i++) {
				FaceppLocalFace *face = [result.faces objectAtIndex:i];
				NSLog(@"    rect = %@, trackingId = %d",
					  NSStringFromCGRect(face.bounds),
					  face.trackingID);
			}
			
			
			[FaceppAPI setDebugMode:NO];
			FaceppResult *OnlineResult = [[FaceppAPI detection] uploadLocalResult:result
																		attribute:FaceppDetectionAttributeAge|FaceppDetectionAttributeGlass|FaceppDetectionAttributeGender
																			  tag:@""];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if (OnlineResult.success) {
					//				double image_width = [[OnlineResult content][@"img_width"] doubleValue] *0.01f;
					//				double image_height = [[OnlineResult content][@"img_height"] doubleValue] * 0.01f;
					
					
					// draw rectangle in the image
					int face_count = [[OnlineResult content][@"face"] count];
					//储存边界,脸宽，角度
					firstCenterArr = [NSMutableArray new];
                    faceWArr = [NSMutableArray new];
                    trangArr = [NSMutableArray new];
                    
                    leftWArr = [NSMutableArray new];
                    leftAngleArr = [NSMutableArray new];
                    //右边镜腿宽加角存储数组
                    rightWArr = [NSMutableArray new];
                    rightAngleArr = [NSMutableArray new];
                    //存储耳朵点
                    earLArr = [NSMutableArray new];
                    earRArr = [NSMutableArray new];
                    
                    newupleftArr = [NSMutableArray new];
                    newuprightArr = [NSMutableArray new];
                    
					//解决有佩戴眼镜时的问题
					int runI = 0;
					for (int i=0; i<face_count; i++) {
						
						NSString* glassNone = [OnlineResult content][@"face"][i][@"attribute"][@"glass"][@"value"];
						if (![glassNone isEqualToString:@"None"]) {
							runI--;
							[GSUtil removeProgressHUB:self.view];
							UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"建议您使用未佩戴眼镜的照片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
							[alert show];
						}else{
							double eye_leftX = [[OnlineResult content][@"face"][i][@"position"][@"eye_left"][@"x"] doubleValue]*kTRYWIDTH*0.01f;
							double eye_leftY = [[OnlineResult content][@"face"][i][@"position"][@"eye_left"][@"y"] doubleValue]*kTRYHEIGHT*0.01f;
							double eye_rightX = [[OnlineResult content][@"face"][i][@"position"][@"eye_right"][@"x"] doubleValue]*kTRYWIDTH*0.01f;
							double eye_rightY = [[OnlineResult content][@"face"][i][@"position"][@"eye_right"][@"y"] doubleValue]*kTRYHEIGHT*0.01f;
							
							NSString*age = [NSString stringWithFormat:@"%@",[OnlineResult content][@"face"][i][@"attribute"][@"age"][@"value"]];
							
							int aV = [age intValue];
							NSString*xingbie;
							if ([[OnlineResult content][@"face"][i][@"attribute"][@"gender"][@"value"] isEqualToString:@"Male"]) {
								xingbie = @"男";
							}else{
								xingbie = @"女";
							}
							
					
                            
                            //眼镜图片处理

							glass= [[UIImageView alloc] initWithImage:glassImg];
							glass.tag = i+runI;

							
							CGFloat scanl = glassImg.size.height/glassImg.size.width;
							CGFloat gx =(eye_rightX+eye_leftX)/2;
							CGFloat gy = (eye_rightY+eye_leftY)/2;
							CGFloat gw = 0.0;
							
							gw = (eye_rightX-eye_leftX)*2.15;
							//imageview因比例已调整
							glass.frame = CGRectMake(0, 0, gw, gw*scanl);
							faceWidth = gw;
							[faceWArr addObject:[NSNumber numberWithFloat:faceWidth]];
							CGPoint newCenter = CGPointMake(gx,gy);
							
							glass.center = newCenter;
							
							//************根据返回位置计算旋转后四个点的坐标 要在旋转前计算
//							CGFloat returnScanl = glass.frame.size.width/tmpImg.size.width;
//							CGFloat upleftX=[entity.upper_left_x integerValue]*returnScanl+glass.frame.origin.x;
//							CGFloat upleftY=[entity.upper_left_y integerValue]*returnScanl+glass.frame.origin.y;
//							CGFloat uprightX=[entity.upper_right_x integerValue]*returnScanl+glass.frame.origin.x;
//							CGFloat upRightY=[entity.upper_right_y integerValue]*returnScanl+glass.frame.origin.y;
//							CGFloat downLeftX=[entity.lower_left_x integerValue]*returnScanl+glass.frame.origin.x;
//							CGFloat downLeftY=[entity.lower_left_y integerValue]*returnScanl+glass.frame.origin.y;
//							CGFloat downRightX=[entity.lower_right_x integerValue]*returnScanl+glass.frame.origin.x;
//							CGFloat downRightY=[entity.lower_right_y integerValue]*returnScanl+glass.frame.origin.y;
							//2014.9.19修改为本地检测
                            
                            CGSize glaSize = glass.frame.size;
                            //左上
                            CGFloat upleftX=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].x+glass.frame.origin.x;
                            CGFloat upleftY=[ImageGetPixelColor getPixelPointInImageLeft:glassImg andSize:glaSize].y+glass.frame.origin.y;
                            //右上
                            CGFloat uprightX=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].x+glass.frame.origin.x;
                            CGFloat upRightY=[ImageGetPixelColor getPixelPointInImageRight:glassImg andSize:glaSize].y+glass.frame.origin.y;
                            //左下
                            CGFloat downLeftX=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].x+glass.frame.origin.x;
                            CGFloat downLeftY=[ImageGetPixelColor getPixelPointInImageLowLeft:glassImg andSize:glaSize].y+glass.frame.origin.y;
                            //右下
                            CGFloat downRightX=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].x+glass.frame.origin.x;
                            CGFloat downRightY=[ImageGetPixelColor getPixelPointInImageLowRight:glassImg andSize:glaSize].y+glass.frame.origin.y;

                        /***************************************/
							
							//转换并存入中心点,角度，脸宽
							[firstCenterArr addObject:NSStringFromCGPoint(newCenter)];
							//旋转后**************
							/**
							 *  旋转
							 *
							 *  @param  公式
							 *
							 *  @return 角度
							 */
							trangle = atan((eye_rightY-eye_leftY)/(eye_rightX-eye_leftX));
                            [trangArr addObject:[NSNumber numberWithFloat:trangle]];
							
							glass.transform=CGAffineTransformMakeRotation(trangle);
							
							
							//旋转后***坐标原点转换
							CGFloat newupleftX = cos(trangle)*(upleftX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
							CGFloat newupleftY = cos(trangle)*(upleftY-newCenter.y)+sin(trangle)*(upleftX-newCenter.x)+newCenter.y;
							
							CGFloat newuprightX = cos(trangle)*(uprightX-newCenter.x)-sin(trangle)*(upleftY-newCenter.y)+newCenter.x;
							CGFloat newuprightY = cos(trangle)*(upRightY-newCenter.y)+sin(trangle)*(uprightX-newCenter.x)+newCenter.y;
							
//							CGFloat newdownleftX = cos(trangle)*(downLeftX-newCenter.x)-sin(trangle)*(downLeftY-newCenter.y)+newCenter.x;
							CGFloat newdownleftY=  cos(trangle)*(downLeftY-newCenter.y)+sin(trangle)*(downLeftX-newCenter.x)+newCenter.y;
							
//							CGFloat newdownrightX = cos(trangle)*(downRightX-newCenter.x)-sin(trangle)*(downRightY-newCenter.y)+newCenter.x;
							CGFloat newdownrightY = cos(trangle)*(downRightY-newCenter.y)+sin(trangle)*(downRightX-newCenter.x)+newCenter.y;
							//传出距眼镜原点差值用于移动时使用
							//左镜腿用
							[newupleftArr addObject:NSStringFromCGPoint(CGPointMake(newupleftX-glass.frame.origin.x, newupleftY-glass.frame.origin.y))];
							//右镜腿用
                            [newuprightArr addObject:NSStringFromCGPoint(CGPointMake(newuprightX-glass.frame.origin.x, newuprightY-glass.frame.origin.y))];
							
//以下是镜腿图片处理******************************************把旋转操作都放到最后进行避免imageview出现问题
							FaceppResult *newResult = [[FaceppAPI detection] landmarkWithFaceId: [OnlineResult content][@"face"][i][@"face_id"] andType:0];
							
							//耳朵旁点坐标
							double earLX = [newResult.content[@"result"][0][@"landmark"][@"contour_left1"][@"x"] doubleValue]*kTRYWIDTH*0.01f;
							
							double earLY = [newResult.content[@"result"][0][@"landmark"][@"contour_left1"][@"y"] doubleValue]*kTRYHEIGHT*0.01f;
							
							double earRX = [newResult.content[@"result"][0][@"landmark"][@"contour_right1"][@"x"] doubleValue]*kTRYWIDTH*0.01f;
							
							double earRY = [newResult.content[@"result"][0][@"landmark"][@"contour_right1"][@"y"] doubleValue]*kTRYHEIGHT*0.01f;
							
                           
							
							
							//左边镜腿
							if (earLX<newupleftX) {
                        
								//左侧翻转镜腿图片
								UIImage *flipLegImg = [UIImage imageWithCGImage:legImg.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
							
								
                                [earLArr addObject:NSStringFromCGPoint(CGPointMake(earLX, earLY))];
						
							UIImageView*llimgView = [[UIImageView alloc] initWithImage:flipLegImg];
								//左边镜腿tag=镜片tag+100
								llimgView.tag = i+runI+1000;

							//先计算镜腿的长宽
								llimgView.frame = CGRectMake(0, 0, sqrt(pow((newupleftY-earLY), 2)+pow((newupleftX-earLX), 2)), newdownleftY-newupleftY);
                                
                                [leftWArr addObject:[NSNumber numberWithFloat:llimgView.frame.size.width]];
								
								//移动到中心点然后再旋转

								//此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
								CGPoint leftCenter = CGPointMake((newupleftX+earLX)/2, (newupleftY+earLY)/2+(newdownleftY-newupleftY)/2);
								llimgView.center = leftCenter;
								
								/**
								 *  旋转,旋转要在最后做，否则image属性改变对应坐标也改变
								 */
								CGFloat legAngle = atan((newupleftY-earLY)/(newupleftX-earLX));
//                                [leftAngleArr addObject:[NSNumber numberWithFloat:legAngle+M_PI]];
//
                                //左右flip
                                llimgView.transform=CGAffineTransformMakeRotation(legAngle);
                                

								[_tryImgView addSubview:llimgView];
							}
                            else{
                                //不佩戴时对数组进行占位赋值，使tag和数组数对应起来
                                [leftWArr addObject:@"占位"];
                                [leftAngleArr addObject:@"占位"];
                                 [earLArr addObject:@"占位"];
                            }
							//右边镜腿
							if (earRX>newuprightX) {
								
                        [earRArr addObject:NSStringFromCGPoint(CGPointMake(earRX, earRY))];
								UIImageView* rlIMgView = [[UIImageView alloc] initWithImage:legImg];
								//右边镜腿tag=镜片tag+101
								rlIMgView.tag = i+runI+10000;
								
								//安坐标适配镜腿大小
								CGRect frame = rlIMgView.frame;
								frame.size.width = sqrt(pow((earRY-newuprightY), 2)+pow((earRX-newuprightX), 2));
								frame.size.height = newdownrightY-newuprightY;
								rlIMgView.frame = frame;
                                [rightWArr addObject:[NSNumber numberWithFloat:rlIMgView.frame.size.width]];
								
								//移动到中心点然后再旋转
								
								//此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
								CGPoint rightCenter = CGPointMake((newuprightX+earRX)/2, (newuprightY+earRY)/2+(newdownrightY-newuprightY)/2);
								rlIMgView.center = rightCenter;
								
								/**
								 *  旋转
								 */
								CGFloat legAngle = atan((earRY-newuprightY)/(earRX-newuprightX));
                                [rightAngleArr addObject:[NSNumber numberWithFloat:legAngle]];
								rlIMgView.transform=CGAffineTransformMakeRotation(legAngle);
								[_tryImgView addSubview:rlIMgView];

							}else{
                                //不佩戴时对数组进行占位赋值，使tag和数组数对应起来
                                [rightWArr addObject:@"占位"];
                                [rightAngleArr addObject:@"占位"];
                                [earRArr addObject:@"占位"];
                            }
							
//****************************以上是镜腿图片处理

                            //镜片图片位于最上层
							[self.tryImgView addSubview:glass];
							[GSUtil removeProgressHUB:self.view];
							
							
							
							UIAlertView *alert = [[UIAlertView alloc]
												  initWithTitle:@"识别信息"
												  message:[NSString stringWithFormat:@"我猜您是%@孩子\n我猜您的年龄是%i岁左右\n我猜的对不对呀？",xingbie,aV]
												  delegate:nil
												  cancelButtonTitle:@"我知道啦!"
												  otherButtonTitles:nil];
							[alert show];
							
						}
						
					}
					
					haShiBie = YES;
				} else {
					[GSUtil removeProgressHUB:self.view];
					// some errors occurred
					UIAlertView *alert = [[UIAlertView alloc]
										  initWithTitle:[NSString stringWithFormat:@"识别失败: %@", [OnlineResult error].message]
										  message:@""
										  delegate:nil
										  cancelButtonTitle:@"OK!"
										  otherButtonTitles:nil];
					[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
					
				}
				[GSUtil removeProgressHUB:self.view];
				if ([[OnlineResult content][@"face"] count]==0) {
					[GSUtil toast:@"识别失败了,请换张照片试试！" ShowInView:self.view];
				}
				
			});
		});
        
	}
	
}
//获得镜腿
-(UIImage*)getGlassTui
{
    NSUserDefaults* defaultIMg = [NSUserDefaults  standardUserDefaults];
	NSData *imageData = [defaultIMg objectForKey:[NSString stringWithFormat:@"%@Tui",self.imgName]];
	UIImageView*cImage = [[UIImageView alloc] init];
	if (imageData)
	{
		
		cImage.image=[UIImage imageWithData:imageData];
		return cImage.image;
		
		
	}
	else
	{
        //第一步，创建URL
		NSString* okImageName = [NSString stringWithFormat:@"http://www.schoolgater.com/get_small_glass.php?url=%@",self.imgName];
		NSURL *url = [NSURL URLWithString:[okImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		//第二步，通过URL创建网络请求
		
		NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		
		//第三步，连接服务器
		
		NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:received
							  
															 options:NSJSONReadingAllowFragments error:nil];
		NSMutableString *urStr = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"url_small_glass"]];
		[urStr insertString:@"+" atIndex:(urStr.length-4)];
		NSString *strUrl= [NSString stringWithFormat:@"http://www.schoolgater.com/%@",urStr];
		
		
        NSString *encodingString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *imgUrl=[NSURL URLWithString:encodingString];
		
		imageData = [NSData dataWithContentsOfURL:imgUrl];
		cImage.image=[UIImage imageWithData:imageData];
		[defaultIMg setObject:imageData forKey:[NSString stringWithFormat:@"%@Tui",self.imgName]];
		[defaultIMg synchronize];
		
		return cImage.image;
    }

}
-(UIImage*)getImg
{
	NSUserDefaults* defaultIMg = [NSUserDefaults  standardUserDefaults];
	NSData *imageData = [defaultIMg objectForKey:self.imgName];
	UIImageView*cImage = [[UIImageView alloc] init];
	if (imageData)
	{
		//第一步，创建URL
		NSString* okImageName = [NSString stringWithFormat:@"http://www.schoolgater.com/get_small_glass.php?url=%@",self.imgName];
		NSURL *url = [NSURL URLWithString:[okImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		//第二步，通过URL创建网络请求
		
		NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		
		//第三步，连接服务器
		
		NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:received
															 options:NSJSONReadingAllowFragments error:nil];
		
		entity = [[SmallGlassEntity alloc] initWithDictionary:dict error:nil];
		cImage.image=[UIImage imageWithData:imageData];
		return cImage.image;
		
		
	}
	else
	{
       		//第一步，创建URL
		NSString* okImageName = [NSString stringWithFormat:@"http://www.schoolgater.com/get_small_glass.php?url=%@",self.imgName];
		NSURL *url = [NSURL URLWithString:[okImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		//第二步，通过URL创建网络请求
		
		NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		
		//第三步，连接服务器
		
		NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:received
															 options:NSJSONReadingAllowFragments error:nil];
		
		entity = [[SmallGlassEntity alloc] initWithDictionary:dict error:nil];
		
		NSString *urStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url_small_glass"]];
		
		NSString *strUrl= [NSString stringWithFormat:@"http://www.schoolgater.com/%@",urStr];
		
		
        NSString *encodingString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *imgUrl=[NSURL URLWithString:encodingString];
		
		imageData = [NSData dataWithContentsOfURL:imgUrl];
		cImage.image=[UIImage imageWithData:imageData];
		[defaultIMg setObject:imageData forKey:self.imgName];
		[defaultIMg synchronize];
		
		return cImage.image;
        }
	
    
	
}


#pragma mark - 以下是剪裁图片方法用的
#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
		[self.popover presentPopoverFromRect:CGRectMake(0, 64, kSCREENWIDTH, kLISTY-64)
									  inView:self.view
					permittedArrowDirections:UIPopoverArrowDirectionAny
									animated:YES];
		
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
  		[self.popover presentPopoverFromRect:CGRectMake(0, 64, kSCREENWIDTH, kLISTY-64)
									  inView:self.view
					permittedArrowDirections:UIPopoverArrowDirectionAny
									animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}


#pragma mark - UIActionSheetDelegate methods

/*
 Open camera or photo album.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Photo Album", nil)]) {
        [self openPhotoAlbum];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        [self showCamera];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//重新选照片移除原来的眼镜
	for (UIView*sub in _tryImgView.subviews) {
		[sub removeFromSuperview];
	}
	[self initboolInfo];
	
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.tryImgView.image = image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        
        [self openEditor];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor];
        }];
    }
}
//明星脸试戴
- (void)writePhoto:(UIImage*)image
{
	//重新选照片移除原来的眼镜
	for (UIView*sub in _tryImgView.subviews) {
		[sub removeFromSuperview];
	}
	[self initboolInfo];
	
    
    self.tryImgView.image = image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        
        [self openEditor];
    } else {
        
            [self openEditor];
      
    }

}

- (void)openEditor
{
	PECropViewController *controller = [[PECropViewController alloc] init];
	//用于固定比例
	//	controller.keepingCropAspectRatio = YES;
	
    controller.delegate = self;
    controller.image = self.tryImgView.image;
	
    //适配
    UIImage *image = self.tryImgView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
	CGFloat newWidth = length;
	CGFloat newHeight = length;
	if (width!=height) {
		if (length == width) {
			newHeight = length*BILI;
		}else{
			newWidth = length/BILI;
		}
		
	}
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          newWidth,
                                          newHeight);
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
	
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.tryImgView.image = croppedImage;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark - move methods移动功能

//移动功能
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
	
    CGPoint point=[touch locationInView:self.tryImgView];
    UIImageView *imgView=[self imagesViewContainsPoint:point];
	startPoint = point;
    //限制点击镜腿不可以执行
    if(imgView!=nil&&imgView.tag<1000)
    {
        moveTag=imgView.tag;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
	
    CGPoint point=[touch locationInView:self.tryImgView];
    //移动的坐标差
	Dx=point.x-startPoint.x;
	
	Dy=point.y-startPoint.y;
	
	
	//排除当未载入画面时的情况
	UIView *view= (moveTag==152)?nil:[self.tryImgView viewWithTag:moveTag];
	CGPoint newupleft = (moveTag==152)?CGPointZero:CGPointFromString(newupleftArr[moveTag]);
	

    
        if(CGRectContainsPoint(view.frame, point))
        {
            
            //计算移动后的矩形框，原点x,y坐标，矩形宽高
            
            CGPoint oringinPoint = view.center;
            
            view.center = CGPointMake(oringinPoint.x + Dx, oringinPoint.y + Dy);
            startPoint = point;
            //获得原位置中心点
            CGPoint oldCenter = CGPointFromString(firstCenterArr[moveTag]);
            //限制移动边界
            CGFloat dert = view.frame.size.width*0.1;
            if ((view.center.x-oldCenter.x)>dert) {
                view.center= CGPointMake(oldCenter.x+dert, view.center.y);
            }
            if ((view.center.x-oldCenter.x)<-dert) {
                view.center= CGPointMake(oldCenter.x-dert, view.center.y);
            }
            if ((view.center.y-oldCenter.y)>dert) {
                view.center= CGPointMake(view.center.x,oldCenter.y+dert);
            }
            if ((view.center.y-oldCenter.y)<-dert) {
                view.center= CGPointMake(view.center.x,oldCenter.y-dert);
            }
            
            //******
            //左镜腿
            UIView *leftLeg =[_tryImgView viewWithTag:moveTag+1000];
            if (leftLeg) {
                //取值转换
             
                CGPoint leftear = CGPointFromString(earLArr[moveTag]);
             
               
                //换图片适配比例
                leftLeg.transform=CGAffineTransformMakeRotation(0);
                CGRect frame = leftLeg.frame;
                frame.size.width = sqrt(pow((view.frame.origin.y+newupleft.y-leftear.y), 2)+pow((view.frame.origin.x+newupleft.x-leftear.x), 2));
                
                leftLeg.frame = frame;
                
                CGPoint leftCenter = CGPointMake((view.frame.origin.x+newupleft.x+leftear.x)/2, (view.frame.origin.y+newupleft.y+leftear.y)/2+(leftLeg.frame.size.height)/2);
                leftLeg.center = leftCenter;
                
                CGFloat legAngle = atan((view.frame.origin.y+newupleft.y-leftear.y)/abs((view.frame.origin.x+newupleft.x-leftear.x)));

                leftLeg.transform=CGAffineTransformMakeRotation(legAngle);
                

            }
            
            //********
            
            //右镜腿
            UIView *rightLeg =[_tryImgView viewWithTag:moveTag+10000];
            if (rightLeg) {
                //取值转换
           
                CGPoint rightear = CGPointFromString(earRArr[moveTag]);
    
                CGPoint newupright = CGPointFromString(newuprightArr[moveTag]);
                //换图片适配比例
                rightLeg.transform=CGAffineTransformMakeRotation(0);
                //安坐标适配镜腿大小
                CGRect frameR = rightLeg.frame;
                frameR.size.width = sqrt(pow((rightear.y-view.frame.origin.y-newupright.y), 2)+pow((rightear.x-view.frame.origin.x-newupright.x), 2));
                rightLeg.frame = frameR;
                
                
                //移动到中心点然后再旋转
                
                //此算法用于计算中心店, 以上面两点为中心然后在加上镜腿的一半
                CGPoint rightCenter = CGPointMake((view.frame.origin.x+newupright.x+rightear.x)/2, (view.frame.origin.y+newupright.y+rightear.y)/2+rightLeg.frame.size.height/2);
                rightLeg.center = rightCenter;
                
                /**
                 *  旋转
                 */
				
                CGFloat legAngleR = atan((rightear.y-(newupright.y+view.frame.origin.y))/abs((rightear.x-(newupright.x+view.frame.origin.x))));
     
                rightLeg.transform=CGAffineTransformMakeRotation(legAngleR);
                
            }

        }
    

}


//查找所在坐标的UIImageView
- (UIImageView *)imagesViewContainsPoint:(CGPoint)point
{
	for (UIView*imgView in [_tryImgView subviews]) {
		if(CGRectContainsPoint(imgView.frame, point))
		{
			return (UIImageView*)imgView;
		}
	}
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
