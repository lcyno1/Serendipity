//
//  SearchList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/30.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SearchList.h"

@implementation SearchList

-(void)dealloc{
    
    [_singer release];
    [_songName release];
    [super dealloc];
    
}


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    return self;
}


+(SearchList *)searchWithDictionary:(NSDictionary *)dictionary{
    
    SearchList *searchList = [[SearchList alloc]initWithDictionary:dictionary];
    
    return [searchList autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
