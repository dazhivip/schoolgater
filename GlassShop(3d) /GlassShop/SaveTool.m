//
//  SaveTool.m
//  GlassShop
//
//  Created by Sarnath RD on 14-3-22.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

#import "SaveTool.h"

@implementation SaveTool


-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
	
    [aCoder encodeObject:self.myTitle forKey:@"myTitle"];
    [aCoder encodeObject:self.myImage  forKey:@"myImage"];
   

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        self.myTitle    = [aDecoder decodeObjectForKey:@"myTitle"];
        self.myImage   = [aDecoder decodeObjectForKey:@"myImage"];
      
    }
	
    return self;
}
@end
