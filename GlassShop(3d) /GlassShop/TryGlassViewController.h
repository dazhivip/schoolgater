//
//  TryGlassViewController.h
//  GlassShop
//
//  Created by Sarnath RD on 14-7-9.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"
#import "MBProgressHUD.h"

@interface TryGlassViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) NSArray *hostArr;

@property (weak, nonatomic) IBOutlet UIImageView *tryImgView;

@property (nonatomic) UIPopoverController *popover;

@property (retain, atomic) UIImageView *glass;

@property (retain, atomic) UIImageView*gLeg;
@property (strong, nonatomic) NSString *imgName;

- (void)writePhoto:(UIImage*)image;
//淘宝向西连接
@property (nonatomic ,strong) NSString *detailViewURl;


@property (nonatomic, assign)NSString*nowID;

- (void)dotoDetailWeb;
@end
