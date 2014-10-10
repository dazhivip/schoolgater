//
//  MyHostViewController.m
//  GlassShop
//
//  Created by Sarnath RD on 14-7-10.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "MyHostViewController.h"
#import "GlassTableViewController.h"
@interface MyHostViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    GlassTableViewController *gVC;
}

@end

@implementation MyHostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
	//    self.title = @"View Pager";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
	//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
	//        self.edgesForExtendedLayout = UIRectEdgeNone;
	//    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _listArr.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = _listArr[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
	gVC = [GlassTableViewController new];
	//传递代理
	gVC.delegate = (id)self.MIdDelegate;
    gVC.view.frame = CGRectMake(0, 20,kSCREENWIDTH, kLISTHEIGHT-20);
    gVC.titStr = _listArr[index];
	return gVC;
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    gVC.titStr = _listArr[index];
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:17/255.0 green:121/255.0 blue:247/255.0 alpha:0.9];
            break;
        default:
            break;
    }
    
    return color;
}

@end
