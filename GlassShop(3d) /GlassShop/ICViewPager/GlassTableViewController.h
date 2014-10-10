//
//  GlassTableViewController.h
//  GlassShop
//
//  Created by Sarnath RD on 14-7-10.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@protocol PeiDaiDelegate <NSObject>

- (void)startPeiDai:(NSString*)name;
- (void)showDetail:(NSString*)price andxing:(NSString*)name forId:(NSString*)gID andUrl:(NSString*)url;

@end
@interface GlassTableViewController : UICollectionViewController


@property (nonatomic, strong) NSString *titStr;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) id<PeiDaiDelegate>delegate;
@end
