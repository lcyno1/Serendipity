//
//  OneMusician.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneMusician.h"

@implementation OneMusician
//NN i c m
-(void)dealloc{
    
    [_NN release];
    [_I release];
    [_C release];
    [_M release];
    [super dealloc];
    
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    return self;
}

+(OneMusician *)oneMusicianWithDictionary:(NSDictionary *)dictionary{
    
    OneMusician *oneMusician = [[OneMusician alloc]initWithDictionary:dictionary];
    
    return [oneMusician autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}

@end
