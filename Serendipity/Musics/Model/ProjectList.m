//
//  ProjectList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/22.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "ProjectList.h"

@implementation ProjectList

-(void)dealloc{
    
    [_Title release];
    [_Url release];
    [_ImgUrl release];
    [super dealloc];
    
    
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    
    return self;
}

+(ProjectList *)projectListWithDictionary:(NSDictionary *)dictionary{
    
    ProjectList *projectList = [[ProjectList alloc]initWithDictionary:dictionary];
    
    return [projectList autorelease];
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
    
}

@end
