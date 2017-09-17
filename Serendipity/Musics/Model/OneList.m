//
//  OneList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneList.h"

@implementation OneList

-(void)dealloc{
    
    [_SN release];
    [_user release];
    [super dealloc];
    
}


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    return self;
}

+(OneList *)oneListWithDictionary:(NSDictionary *)dictionary{
    
    OneList *oneList = [[OneList alloc]initWithDictionary:dictionary];
    
    return [oneList autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}


@end
