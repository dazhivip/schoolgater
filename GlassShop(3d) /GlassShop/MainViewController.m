//
//  MainViewController.m
//  GlassShop
//
//  Created by Sarnath RD on 14-7-9.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "MainViewController.h"
#import "GSUtil.h"

#import "TryGlassViewController.h"
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>

@interface MainViewController ()<MBProgressHUDDelegate,SKStoreProductViewControllerDelegate>

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBarHidden = YES;
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initView];
	
}

- (void)initRequest
{
	 [GSUtil addProgressHUBInView:self.view textInfo:nil delegate:self];
   [[logicShareInstance getStarsManager] getCategorySuccess:^(id responseObject) {
	   [GSUtil removeProgressHUB:self.view];
	   NSString *suc = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
	   if ([suc isEqualToString:@"1"]) {
		   
           //静态保留tryView
           static TryGlassViewController *viewCtrl = NULL;
           static dispatch_once_t onceToken;
           dispatch_once(&onceToken, ^{
               viewCtrl = [[TryGlassViewController alloc] init];
           });
		   viewCtrl.hostArr = responseObject[@"category"];
		   [self.navigationController pushViewController:viewCtrl animated:NO];
	   }else{
		   [GSUtil toast:@"webfail" ShowInView:self.view];
	   }

   } failure:^(id responseObject) {
	   [GSUtil removeProgressHUB:self.view];
	   [GSUtil toast:@"连网失败" ShowInView:self.view];

   }];
}

- (void)initView{
//	_boyBtn.layer.cornerRadius = 5.0;

	if (IS_IOS7) {
		_aboutBtn.layer.cornerRadius = 5.0;
		_aboutBtn.backgroundColor = [UIColor whiteColor];
		_zhaomuBtn.layer.cornerRadius = 5.0;
		_zhaomuBtn.backgroundColor = [UIColor whiteColor];
		[GSUtil setBorderforView:_aboutBtn];
		[GSUtil setBorderforView:_zhaomuBtn];
	}
	[GSUtil setBorderforView:_boyBtn];
	
}
- (IBAction)boyBtnDown:(id)sender {
	
    [self initRequest];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            //打开appstore
            SKStoreProductViewController *storeView = [SKStoreProductViewController new];
            [storeView setDelegate:self];
            [storeView loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier :@"853827407"} completionBlock:nil];
            [self presentViewController:storeView animated:YES completion:nil];
            
        }
    }
}
//appstorekit代理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
