//
//  MyHostViewController.h
//  GlassShop
//
//  Created by Sarnath RD on 14-7-10.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "ViewPagerController.h"
#import <QuartzCore/QuartzCore.h>
@interface MyHostViewController : ViewPagerController

@property (nonatomic ,strong) NSArray *listArr;

@property (nonatomic,strong) UIViewController* MIdDelegate;
@end
