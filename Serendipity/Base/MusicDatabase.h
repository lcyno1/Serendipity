//
//  MusicDatabase.h
//  Serendipity
//
//  Created by 李重阳 on 16/1/2.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicDatabase : NSObject

+(MusicDatabase *)musicDatabase;

-(void)openMusicDatabase;

-(void)createTable;

-(void)insertMusic:(NSDictionary *)music;

-(void)insertHistory:(NSDictionary *)music;

-(void)deleteMusic:(NSDictionary *)music;

-(BOOL)selecMusic:(NSString *)SN;

-(NSArray *)selectAllMusic;

-(NSArray *)historyAllMusic;

@end
