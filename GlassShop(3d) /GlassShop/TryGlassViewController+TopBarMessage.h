//
//  UIViewController+TopBarMessage.h
//  DXTopBarMessageView
//
//  Created by xiekw on 14-3-17.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TryGlassViewController.h"
@interface TopWarningView : UIView

@property (nonatomic, strong) NSString *warningText;
@property (nonatomic, strong) UIButton *iconIgv;
@property (nonatomic, strong) UIButton * delet;


@end


@interface TryGlassViewController (TopBarMessage)

- (void)showTopMessage:(NSString *)warningText AndTit:(NSString*)tit;



//@property (nonatomic, assign)NSString*detailUrl;

@end
