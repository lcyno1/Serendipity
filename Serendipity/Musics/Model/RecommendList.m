//
//  RecommendList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "RecommendList.h"

@implementation RecommendList

-(void)dealloc{
    //playCount title picture songListId

    [_title release];
    [_picture release];
    [_songListId release];
    [super dealloc];
    
}


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    
    return self;
    
}

+(RecommendList *)recommendListWithDictionary:(NSDictionary *)dictionary{
    
    RecommendList *recommendList = [[RecommendList alloc]initWithDictionary:dictionary];
    
    
    return [recommendList autorelease];
    
}

//容错方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}



@end
