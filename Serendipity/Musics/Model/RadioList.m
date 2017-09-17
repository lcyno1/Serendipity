//
//  RadioList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "RadioList.h"

@implementation RadioList

//desc radioid  title userinfo

-(void)dealloc{
    
    [_desc release];
    [_radioid release];
    [_title release];
    [_userinfo release];
    [_coverimg release];
    [super dealloc];
    
}

-(id)initWithDcitionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    return self;
}

+(RadioList *)radioListWithDcitionary:(NSDictionary *)dictionary{
    
    RadioList *radioList = [[RadioList alloc]initWithDcitionary:dictionary];
    
    return [radioList autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
    
}


@end
