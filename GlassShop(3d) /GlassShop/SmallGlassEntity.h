//
//  SmallGlassEntity.h
//  GlassShop
//
//  Created by Sarnath RD on 14-9-1.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "JSONModel.h"

@interface SmallGlassEntity : JSONModel

@property (nonatomic ,assign) NSInteger success;

//镜片图片坐标参数
@property (nonatomic ,strong) NSString <Optional>*url_small_glass;
@property (nonatomic ,strong) NSString <Optional>*glass_size;
@property (nonatomic ,strong) NSString <Optional>*upper_left_x;
@property (nonatomic ,strong) NSString <Optional>*upper_left_y;
@property (nonatomic ,strong) NSString <Optional>*lower_left_x;
@property (nonatomic ,strong) NSString <Optional>*lower_left_y;
@property (nonatomic ,strong) NSString <Optional>*upper_right_x;
@property (nonatomic ,strong) NSString <Optional>*upper_right_y;
@property (nonatomic ,strong) NSString <Optional>*lower_right_x;
@property (nonatomic ,strong) NSString <Optional>*lower_right_y;

//镜腿参数
@property (nonatomic ,strong) NSString <Optional>*upper_left_x_cemian;
@property (nonatomic ,strong) NSString <Optional>*upper_left_y_cemian;
@property (nonatomic ,strong) NSString <Optional>*upper_right_x_cemian;
@property (nonatomic ,strong) NSString <Optional>*upper_right_y_cemian;
@end
