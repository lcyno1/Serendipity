//
//  Charts.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charts : NSObject
/*
 "id": "yc",
 "name": "原创排行榜",
 "photo": "http://static.5sing.kugou.com/images/mobile_rank/new/yc.png",
 "songs": [
 "光刃·剑中歌-萧忆情Alex",
 "[原创] 归雁（五音六律原创团队重编版）-月吟诗",
 "【聆音】明月天涯-五音Jw",
 "心乡我乡——《义犹未尽》原创古风音乐专辑-小义学长"
*/

@property(nonatomic,copy)NSString *ID;  //歌单id

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *photo;  //图片地址

@property(nonatomic,retain)NSArray *songs;  //三首歌

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(Charts *)chartsWithDictionary:(NSDictionary *)dictionary;


@end
