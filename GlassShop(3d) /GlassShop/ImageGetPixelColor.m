//
//  ImageGetPixelColor.m
//  GlassShop
//
//  Created by Sarnath RD on 14-8-26.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "ImageGetPixelColor.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation ImageGetPixelColor
//左上取点
+ (CGPoint) getPixelPointInImageLeft:(UIImage *)image andSize:(CGSize)size
{
	CGImageRef inImage = image.CGImage;
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
	//图像左上角起点检测左边
    CGContextRef cgctx = [ImageGetPixelColor createARGBBitmapContextFromImage:
						  inImage];

    CGRect rect = {{0,0},{w,h}};
	
    CGContextDrawImage(cgctx, rect, inImage);
	
    unsigned char* data = CGBitmapContextGetData (cgctx);
	int alpha=0;
    int offset=0;
    CGPoint point ;
    if (data != NULL) {
        for (int x=0; x<w; x++) {
            for (int y=0; y<h; y++) {
                point  = CGPointMake(x, y);
                
                offset= 4*((w*round(point.y))+round(point.x));
                alpha =  data[offset];
                if (alpha>100) {
                    CGPoint newPoint = CGPointMake(point.x/w*size.width, point.y/h*size.height);
                    return newPoint;
                    
                }
            }
        }
		
   
    }
	
    CGContextRelease(cgctx);
	
    if (data) { free(data); }
	if (inImage){free(inImage);}
	return CGPointZero;
}

//右上取点
+ (CGPoint) getPixelPointInImageRight:(UIImage *)image andSize:(CGSize)size
{
	CGImageRef inImage = image.CGImage;
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
	
	//图像右上角起点检测右边
    CGContextRef cgctx = [ImageGetPixelColor createARGBBitmapContextFromImage:inImage];
            
    CGRect rect = {{0,0},{w,h}};
            
    CGContextDrawImage(cgctx, rect, inImage);
            
    unsigned char* data = CGBitmapContextGetData (cgctx);
    int alpha=0;
    int offset=0;
    CGPoint point;
    if (data != NULL) {
    for (int x=w; x>0; x--) {
        for (int y=0; y<h; y++) {

            point = CGPointMake(x, y);
                        
            offset= 4*((w*round(point.y))+round(point.x));
            alpha =  data[offset];
            if (alpha>100) {
                    CGPoint newPoint = CGPointMake(point.x/w*size.width, point.y/h*size.height);
                    return newPoint;
                            
                }
                }
                }
                
                
            }
            
            CGContextRelease(cgctx);
            
            if (data) { free(data); }
	if (inImage){free(inImage);}
	return CGPointZero;
}

//左下取点
+ (CGPoint) getPixelPointInImageLowLeft:(UIImage *)image andSize:(CGSize)size
{
	CGImageRef inImage = image.CGImage;
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
	
	//图像左下角起点检测左边
				CGContextRef cgctx = [ImageGetPixelColor createARGBBitmapContextFromImage:
                                  inImage];
            
            CGRect rect = {{0,0},{w,h}};
            
            CGContextDrawImage(cgctx, rect, inImage);
            
            unsigned char* data = CGBitmapContextGetData (cgctx);
            int alpha=0;
            int offset=0;
            CGPoint point;
            if (data != NULL) {
                for (int x=0; x<w; x++) {
                    for (int y=h-2; y>0; y--) {

                       point = CGPointMake(x, y);
                        
                        offset= 4*((w*round(point.y))+round(point.x));
                        alpha =  data[offset];
                        if (alpha>100) {
                            CGPoint newPoint = CGPointMake(point.x/w*size.width, point.y/h*size.height);
                            return newPoint;
                            
                        }
                    }
                }
                
                
            }
            
            CGContextRelease(cgctx);
            
            if (data) { free(data); }
	if (inImage){free(inImage);}
	return CGPointZero;
}

//右下取点
+ (CGPoint) getPixelPointInImageLowRight:(UIImage *)image andSize:(CGSize)size
{
	CGImageRef inImage = image.CGImage;
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
	
	//图像右下角起点检测右边
	
			CGContextRef cgctx = [ImageGetPixelColor createARGBBitmapContextFromImage:
                                  inImage];
            
            CGRect rect = {{0,0},{w,h}};
            
            CGContextDrawImage(cgctx, rect, inImage);
            
            unsigned char* data = CGBitmapContextGetData (cgctx);
            int alpha=0;
            int offset=0;
            CGPoint point;
            if (data != NULL) {
                for (int x=w; x>0; x--) {
                    for (int y=h-2; y>0; y--) {
                        point = CGPointMake(x, y);
                        
                        offset= 4*((w*round(point.y))+round(point.x));
                        alpha =  data[offset];
                        if (alpha>100) {
                            CGPoint newPoint = CGPointMake(point.x/w*size.width, point.y/h*size.height);
                            return newPoint;
                            
                        }
                    }
                }
                
                
            }
            
            CGContextRelease(cgctx);
            
            if (data) { free(data); }
	if (inImage){free(inImage);}
	return CGPointZero;
}

//一、像素点颜色取样
+ (int) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image {
	
//    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [ImageGetPixelColor createARGBBitmapContextFromImage:
						  inImage];
	
    if (cgctx == NULL) { return 0; /* error */ }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
	
    CGContextDrawImage(cgctx, rect, inImage);
	
    unsigned char* data = CGBitmapContextGetData (cgctx);
	int alpha=0;
    if (data != NULL) {
		int offset = 4*((w*round(point.y))+round(point.x));
		alpha =  data[offset];
//		int red = data[offset+1];
//		int green = data[offset+2];
//		int blue = data[offset+3];
//		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,
//			  blue,alpha);
		
//		NSLog(@"x:%f y:%f", point.x, point.y);
//		
//		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
//				 (blue/255.0f) alpha:(alpha/255.0f)];
    }
	
    CGContextRelease(cgctx);
	
    if (data) { free(data); }
	
    return alpha;
	
}
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
	
	CGColorSpaceRef colorSpace;
	
	void *          bitmapData;
	
	int             bitmapByteCount;
	
	int             bitmapBytesPerRow;
	
	size_t pixelsWide = CGImageGetWidth(inImage);
	
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	bitmapBytesPerRow   = (pixelsWide * 4);
	
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
		
	{
		
		fprintf(stderr, "Error allocating color space\n");
		
		return NULL;
		
	}
	
	bitmapData = malloc( bitmapByteCount );
	
	if (bitmapData == NULL)
		
	{
		
		fprintf (stderr, "Memory not allocated!");
		
		CGColorSpaceRelease( colorSpace );
		
		return NULL;
		
	}
	
	context = CGBitmapContextCreate (bitmapData,
									 
									 pixelsWide,
									 
									 pixelsHigh,
									 
									 8,
									 
									 bitmapBytesPerRow,
									 
									 colorSpace,
									 
									 kCGImageAlphaPremultipliedFirst);
	
	if (context == NULL)
		
	{
		
		free (bitmapData);
		
		fprintf (stderr, "Context not created!");
		
	}  
	
	CGColorSpaceRelease( colorSpace );  
	
	return context;  
	
}
@end
