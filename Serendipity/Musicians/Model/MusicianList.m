//
//  MusicianList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusicianList.h"

@implementation MusicianList


-(void)dealloc{
    
    [_NN release];
    [_I release];
    [_M release];
    [_song release];
    [super dealloc];
    
}

-(id)initWitnDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    
    }
    
    return self;
}

+(MusicianList *)musicianListWitnDictionary:(NSDictionary *)dictionary{
    
    
    MusicianList *musicianList = [[MusicianList alloc]initWitnDictionary:dictionary];
    
    return [musicianList autorelease];
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
    
    
}

@end
