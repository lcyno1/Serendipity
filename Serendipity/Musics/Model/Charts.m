//
//  Charts.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "Charts.h"

@implementation Charts

-(void)dealloc{
    
    [_ID release];
    [_name release];
    [_photo release];
    [_songs release];
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    
    return self;
}


+(Charts *)chartsWithDictionary:(NSDictionary *)dictionary{
    
    Charts *charts = [[Charts alloc]initWithDictionary:dictionary];
    
    return [charts autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
        
    }
    
    
}



@end
