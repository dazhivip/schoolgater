//
//  ImageGetPixelColor.h
//  GlassShop
//
//  Created by Sarnath RD on 14-8-26.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageGetPixelColor : NSObject

//一、像素点颜色取样//左边上
+ (CGPoint) getPixelPointInImageLeft:(UIImage *)image andSize:(CGSize)size;

//右边上
+ (CGPoint) getPixelPointInImageRight:(UIImage *)image andSize:(CGSize)size;

//左下取点
+ (CGPoint) getPixelPointInImageLowLeft:(UIImage *)image andSize:(CGSize)size;
//右下取点
+ (CGPoint) getPixelPointInImageLowRight:(UIImage *)image andSize:(CGSize)size;
@end
