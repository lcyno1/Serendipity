//
//  WorkList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "WorkList.h"

@implementation WorkList

//sn fn sw u
-(void)dealloc{
    
    [_FN release];
    [_SN release];
    [_SW release];
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

+(WorkList *)workListWithDictionary:(NSDictionary *)dictionary{
    
    WorkList *workList = [[WorkList alloc]initWithDictionary:dictionary];
    
    return [workList autorelease];
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

@end
