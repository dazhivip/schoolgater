//
//  AppDelegate.m
//  GlassShop
//
//  Created by Sarnath RD on 14-2-25.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "AppDelegate.h"


#import "MainViewController.h"
#import "Util.h"
#import "UserEntity.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
	
    //		self.window.rootViewController = nil;
		MainViewController *mainView= [MainViewController new];
	
        self.nav = [[UINavigationController alloc] initWithRootViewController:mainView];

    self.window.rootViewController = self.nav;
	//	初始化启动画面，导入登陆界面
    [self.window makeKeyAndVisible];
//    NSArray*keyArr = @[@"1d1d6dcb2aaebeb182d4a24b9d3f82ed",@"66c43fc30c513cc229c0f6ea36320cd6",@"0fa1b2b411acc48d8beb2c64f337a6d0",@"ffdcbf4590b2f07e278ec42c1aa86aee",@"16089c70fc4d08bb11c7c00d7b3bd3fb",@"ded0b99e11c365aa585377337a3cd84b",@"3d6072031a8be37ccc317c010b4c88c5",@"abd8fe2eea71021b12d2fb9978f3b83b",@"ff6734320fb181c170f293874dc7169d"];
//        NSArray *secretArr = @[@"t- bqgBMZ4lxdIEHaKZ06U_L6kOKI4rFg",@"5rlM3ffsK0D5NFtVa0_4X73Lj__G4MjZ",@"xFz54pDjVZocj4VRnlUJHCYdG8wwqtQd  ",@"PNu3l36BkLuH9K9gw0Vs8cdy4bqcjjZD",
//                               @"1MsoYfy6tkXkQa13nP3rk4nmHUJTR0LM",@"qbvxSls4Log7hp63j3QHOzI0IHyPYqOq",@"W- QQCYQQ41cdPgaRNwE-uT3OHd_NckXT",@"dep_WgFk- HDiS3XSJ1hDspahwewPqw97",@"gdXv4AfIp3-7_zPMU2tddXHOOj15S9MZ"];
//    int k = arc4random()%9;
//    [FaceppAPI initWithApiKey:keyArr[k] andApiSecret:secretArr[k] andRegion:APIServerRegionCN];
	
//    [[logicShareInstance getStarsManager] getFaceAPIKEYsuccess:^(id responseObject) {
//        
//    } failure:^(id responseObject) {
//        
//    }];
	[FaceppAPI initWithApiKey:@"ff6734320fb181c170f293874dc7169d" andApiSecret:@"gdXv4AfIp3-7_zPMU2tddXHOOj15S9MZ" andRegion:APIServerRegionCN];
	UserEntity *user = [Util getCurrentUserInfo];
//	user.faceAPIKey = keyArr[k];
	user.faceAPIKey = @"ff6734320fb181c170f293874dc7169d";
	
	
   
    return YES;
}


-(void)initTab
{
   
//    PersonalityViewController *personnalityView = [[PersonalityViewController alloc] initWithNibName:@"PersonalityViewController" bundle:nil];
//	personnalityView.title = @"收藏夹";
//
//	ChooseGlassViewController *chooseGlassView = [[ChooseGlassViewController alloc] initWithNibName:@"ChooseGlassViewController" bundle:nil];
//	chooseGlassView.title = @"选眼镜";
//	
//	AccountsViewController *accountsView = [[AccountsViewController alloc] initWithNibName:@"AccountsViewController" bundle:nil];
//	accountsView.title = @"帐号";
//	
//	SetupViewController *setupView = [[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil];
//	setupView.title = @"校门口";
//	
//
//   
//    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:chooseGlassView];
//    
//    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:personnalityView];
//    
//    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:accountsView];
//    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:setupView];
//
    
//    self.tabBarController = [[RootController alloc] init];
//    
//    NSMutableArray *arr = [NSMutableArray arrayWithObjects:navigationController1,navigationController2,navigationController3,navigationController4, nil];
//    self.tabBarController.viewControllers=arr;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


@end
