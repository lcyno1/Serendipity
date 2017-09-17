//
//  FamousList.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "FamousList.h"

@implementation FamousList

-(void)dealloc{
    
    [_NickName release];
    [_Portrait release];
    [_M release];
    [_NN release];
    [_I release];
//    [_Song release];
    [super dealloc];
    
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
    
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

+(FamousList *)famousListWithDictionary:(NSDictionary *)dictionary{
    
    FamousList *famousList = [[FamousList alloc]initWithDictionary:dictionary];
    
    
    return [famousList autorelease];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
//    if ([key isEqualToString:@"Song"]) {
//        
//
//            self.SN = [value objectForKey:@"SN"];
//   
//            self.songName = [value objectForKey:@"SongName"];
//      
//        
//        
//    }
    
    

}




@end
