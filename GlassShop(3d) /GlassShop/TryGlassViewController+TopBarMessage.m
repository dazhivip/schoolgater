//
//  UIViewController+TopBarMessage.m
//  DXTopBarMessageView
//
//  Created by xiekw on 14-3-17.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "TryGlassViewController+TopBarMessage.h"
#import <objc/runtime.h>


@interface  TopWarningView()

@property (nonatomic, strong) UILabel *label;

@end

@implementation TopWarningView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//        self.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
		self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:11.0f];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.label];
        
        self.iconIgv = [UIButton new];
		self.iconIgv.userInteractionEnabled = YES;
		self.iconIgv.layer.cornerRadius = 3.0;
		
		
		self.iconIgv.titleLabel.font = [UIFont systemFontOfSize:15];
		[self.iconIgv setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		self.iconIgv.backgroundColor = [UIColor colorWithRed:130/225.0 green:193/255.0 blue:254/255.0 alpha:1];
        [self addSubview:self.iconIgv];
		
		self.delet = [UIButton buttonWithType:0];
		[self.delet addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
		self.delet.backgroundColor = [UIColor clearColor];
		UIImageView*image = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7,16 , 16)];
		image.image = [UIImage imageNamed:@"yuanCha"];
		[self.delet addSubview:image];
		[self addSubview:self.delet];
		
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize textSize = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds) * 0.9, 20.f) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat betweenIconAndText  = 10.0f;
    CGFloat iconWidth = 60.0f;
	CGFloat iconHeight = 25.0f;
	CGFloat btnWidth = 30.0f;
	//    if (!self.iconIgv.image) {
	//        iconWidth = 0.0f;
	//    }
	//编号的简介
	self.label.frame = CGRectMake(25, (CGRectGetHeight(self.bounds) - textSize.height) * 0.5, textSize.width, textSize.height);
	//价格按钮进入详细
    self.iconIgv.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + betweenIconAndText, (CGRectGetHeight(self.bounds) - iconHeight) * 0.5, iconWidth, iconHeight);
    	//	self.delet.frame = CGRectMake(CGRectGetMaxX(self.iconIgv.frame)+CGRectGetWidth(self.label.frame)+betweenIconAndText, (CGRectGetHeight(self.bounds) - btnWidth) * 0.5, btnWidth, btnWidth);
	//收起弹出框
	self.delet.frame = CGRectMake(290, 0, btnWidth, btnWidth);
}

- (void)setWarningText:(NSString *)warningText
{
    _warningText = warningText;
    self.label.text = _warningText;
    [self setNeedsLayout];
}

- (void)removeFromSuperview
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x -= CGRectGetWidth(selfFrame);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = selfFrame;
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.alpha = 1.0;
        CGRect selfFrame = self.frame;
        selfFrame.origin.x -= CGRectGetWidth(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.x = 0;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = selfFrame;
        } completion:^(BOOL finished) {
            [super willMoveToSuperview:newSuperview];
        }];
    }else {
        [super willMoveToSuperview:newSuperview];
    }
}

@end

static char TopWarningKey;
static char kNewPropertyKey;
static char KDetailUrl;
@implementation TryGlassViewController (TopBarMessage)
//@dynamic nowID;
- (void)showTopMessage:(NSString *)warningText AndTit:(NSString *)tit
{
    TopWarningView *topV = objc_getAssociatedObject(self, &TopWarningKey);
	CGFloat tY = IS_IOS7? 314:250;
	CGFloat tH = IS_IOS7? 30:30;
    if (!topV) {
        topV = [[TopWarningView alloc] initWithFrame:CGRectMake(0, tY, CGRectGetWidth(self.view.bounds), tH)];
        objc_setAssociatedObject(self, &TopWarningKey, topV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
	
    topV.frame = CGRectMake(0, tY, CGRectGetWidth(self.view.bounds), tH);
    
    [topV.iconIgv setTitle:[NSString stringWithFormat:@"￥%@",tit] forState:UIControlStateNormal];

    topV.warningText = warningText;
    [self.view addSubview:topV];
    
	//    double delayInSeconds = 3.0;
	//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
	//        [topV removeFromSuperview];
	//    });
}

- (NSString*)nowID
{
    return objc_getAssociatedObject(self, &kNewPropertyKey);
}
- (void)setNowID:(NSString *)nowID
{
    objc_setAssociatedObject(self, &kNewPropertyKey, nowID,OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*)detailUrl{
    return objc_getAssociatedObject(self, &KDetailUrl);
}
- (void)setDetailUrl:(NSString *)detailUrl
{
    objc_setAssociatedObject(self, &KDetailUrl, detailUrl,OBJC_ASSOCIATION_ASSIGN);
}
@end
