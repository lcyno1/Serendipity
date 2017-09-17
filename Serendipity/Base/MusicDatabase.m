//
//  MusicDatabase.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/2.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "MusicDatabase.h"
#import <sqlite3.h>



@implementation MusicDatabase

+(MusicDatabase *)musicDatabase{
    
    static MusicDatabase *musicDatabase = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        musicDatabase = [[MusicDatabase alloc]init];
        
    });
    
    return musicDatabase;
    
}

static sqlite3 *mdb = nil;

-(void)openMusicDatabase{
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *databasePath = [documentPath stringByAppendingString:@"/Music.sqlite"];
    
    if (mdb) {
        
        NSLog(@"打开数据库");
        
        return;
    }
    
    int result = sqlite3_open(databasePath.UTF8String, &mdb);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"打开成功");
    }else{
        
        NSLog(@"打开失败%d",result);
        
    }
    
    NSLog(@"%@",databasePath);
    
}

-(void)createTable{
    
    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists MusicList(SN primary key,SW text,musicUrl text,userName text,picture text)"];
    
    NSString *sqlString1 = [NSString stringWithFormat:@"create table if not exists HistoryList(SN primary key,SW text,musicUrl text,userName text,picture text)"];
    
    int result = sqlite3_exec(mdb, sqlString.UTF8String, NULL, NULL, nil);
    
    int result1 = sqlite3_exec(mdb, sqlString1.UTF8String, NULL, NULL, nil);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"创建表成功");
    }else{
        
        NSLog(@"创建表失败%d",result);
        
    }
    
    if (result1 == SQLITE_OK) {
        
        NSLog(@"创建表成功1");
    }else{
        
        NSLog(@"创建表失败%d1",result);
        
    }
    
    
    
}

-(void)insertMusic:(NSDictionary *)music{
    
    NSString *sqlString = [NSString stringWithFormat:@"insert into  MusicList(SN,SW,musicUrl,userName,picture) values('%@', '%@', '%@', '%@' ,'%@')",[music objectForKey:@"SN"],[music objectForKey:@"SW"],[music objectForKey:@"musicUrl"],[music objectForKey:@"userName"],[music objectForKey:@"picture"]];
    
    int result = sqlite3_exec(mdb, sqlString.UTF8String, NULL, NULL, nil);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"%@插入成功",[music objectForKey:@"SN"]);
        
    }else{
        
        NSLog(@"插入失败%d",result);
        
    }

    
}

-(void)deleteMusic:(NSDictionary *)music{
    
    NSString *sqlString = [NSString stringWithFormat:@"delete from MusicList where SN = '%@'",[music objectForKey:@"SN"]];
    
    int result = sqlite3_exec(mdb, sqlString.UTF8String, NULL, NULL, nil);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"%@删除成功",[music objectForKey:@"SN"]);
        
    }
    else{
        
        NSLog(@"删除失败%d",result);
        
    }


}


- (void)insertHistory:(NSDictionary *)music{
    
    NSString *sqlString = [NSString stringWithFormat:@"insert into  HistoryList(SN,SW,musicUrl,userName,picture) values('%@', '%@', '%@', '%@' ,'%@')",[music objectForKey:@"SN"],[music objectForKey:@"SW"],[music objectForKey:@"musicUrl"],[music objectForKey:@"userName"],[music objectForKey:@"picture"]];
    
    int result = sqlite3_exec(mdb, sqlString.UTF8String, NULL, NULL, nil);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"%@插入成功",[music objectForKey:@"SN"]);
        
    }else{
        
        NSLog(@"插入失败%d",result);
        
    }
    
}

-(BOOL)selecMusic:(NSString *)SN{
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from  MusicList where SN = '%@'", SN];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(mdb, sqlString.UTF8String, -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        //如果跟随对象中有一条数据，就说明该音乐已经收藏在数据库中，所以返回YES，反之返回NO。
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            return YES;
        }else
        {
            return NO;
        }
    }else
    {
        NSLog(@"查询失败%d", result);
        return NO;
    }
    
}

-(NSArray *)selectAllMusic{
    
    NSString *sqlString = @"select *from MusicList";
    
    sqlite3_stmt *tmt = nil;
    
    int result = sqlite3_prepare_v2(mdb, sqlString.UTF8String, -1, &tmt, nil);
    
    NSMutableArray *musics = [NSMutableArray array];
    
    
    if (result == SQLITE_OK) {
        
        
        NSLog(@"查找成功");
        
        while (sqlite3_step(tmt) == SQLITE_ROW) {
            
            const unsigned char *SN = sqlite3_column_text(tmt, 0);
            
            const unsigned char *SW = sqlite3_column_text(tmt, 1);
            
            const unsigned char *musicUrl = sqlite3_column_text(tmt, 2);
            
            const unsigned char *userName = sqlite3_column_text(tmt, 3);
            
            const unsigned char *picture = sqlite3_column_text(tmt, 4);
            

            
            NSDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(const char *)SN],@"SN",[NSString stringWithUTF8String:(const char *)SW],@"SW",[NSString stringWithUTF8String:(const char *)musicUrl],@"musicUrl",[NSString stringWithUTF8String:(const char *)userName],@"userName",[NSString stringWithUTF8String:(const char *)picture],@"picture", nil];
            
            [musics addObject:dic];
            

        }
        
    }else{
        
        NSLog(@"查询失败%d",result);
        
    }
    
    return musics;
}

- (NSArray *)historyAllMusic{
    
    NSString *sqlString = @"select *from HistoryList";
    
    sqlite3_stmt *tmt = nil;
    
    int result = sqlite3_prepare_v2(mdb, sqlString.UTF8String, -1, &tmt, nil);
    
    NSMutableArray *musics = [NSMutableArray array];
    
    
    if (result == SQLITE_OK) {
        
        
        NSLog(@"查找成功");
        
        while (sqlite3_step(tmt) == SQLITE_ROW) {
            
            const unsigned char *SN = sqlite3_column_text(tmt, 0);
            
            const unsigned char *SW = sqlite3_column_text(tmt, 1);
            
            const unsigned char *musicUrl = sqlite3_column_text(tmt, 2);
            
            const unsigned char *userName = sqlite3_column_text(tmt, 3);
            
            const unsigned char *picture = sqlite3_column_text(tmt, 4);
            
            
            
            NSDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(const char *)SN],@"SN",[NSString stringWithUTF8String:(const char *)SW],@"SW",[NSString stringWithUTF8String:(const char *)musicUrl],@"musicUrl",[NSString stringWithUTF8String:(const char *)userName],@"userName",[NSString stringWithUTF8String:(const char *)picture],@"picture", nil];
            
            [musics addObject:dic];
            
            
        }
        
    }else{
        
        NSLog(@"查询失败%d",result);
        
    }
    
    return musics;
}


@end
