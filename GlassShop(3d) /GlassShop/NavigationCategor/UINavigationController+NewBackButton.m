//
//  UINavigationController+NewBackButton.m
//  Diancai
//
//  Created by SarnathAir on 13-10-16.
//  Copyright (c) 2013年 SarnathAir. All rights reserved.
//

#import "UINavigationController+NewBackButton.h"

@implementation UINavigationController (NewBackButton)

-(NSArray*)getNewBackButtons
{
    UIButton *backbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 3, 70, 40)];
//    [backbtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backbtn addTarget:self action:@selector(popview:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"bt_back_up"] forState:UIControlStateNormal];
//    [backbtn setBackgroundImage:[UIImage imageNamed:@"backbt_down"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftitem=[[UIBarButtonItem alloc] initWithCustomView:backbtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    
                                       target:nil action:nil];
    if(IS_IOS7)
        negativeSpacer.width = -15;
    else
        negativeSpacer.width = 0;
    NSArray *arr = [NSArray arrayWithObjects:negativeSpacer,leftitem, nil];
    
    return arr;
}



-(void)popview:(UIButton *)sender
{
    [self popViewControllerAnimated:YES];
}

@end
