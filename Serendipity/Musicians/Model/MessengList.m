//
//  MessengList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/27.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MessengList.h"

@implementation MessengList

-(void)dealloc{
    
    [_content release];
    [_createTime release];
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

+(MessengList *)messengListWithDictionary:(NSDictionary *)dictionary{
    
    MessengList *messengList = [[MessengList alloc]initWithDictionary:dictionary];
    
    return [messengList autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


@end
