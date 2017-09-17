//
//  SongList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SongList.h"

@implementation SongList

-(void)dealloc{
    
    [_ID release];
    [_T release];
    [_P release];
    [super dealloc];
    
    
}


- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    return self;
}

+ (SongList *)songListWithDictionary:(NSDictionary *)dictionary{
    
    SongList *songList = [[SongList alloc]initWithDictionary:dictionary];
    
    return [songList autorelease];////
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"listName"]) {
        self.T = value;
    }
    if ([key isEqualToString:@"playcount"]) {
        self.H = value;
    }
    if ([key isEqualToString:@"url"]) {
        self.P = value;
    }
    if ([key isEqualToString:@"listId"]) {
        self.ID = value;
    }
    
    
}

@end
