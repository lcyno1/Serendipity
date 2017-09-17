//
//  OneList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//  具体歌单每个cell

#import <Foundation/Foundation.h>

@interface OneList : NSObject

@property(nonatomic,assign)NSInteger ID; //歌曲ID

@property(nonatomic,copy)NSString *SN;  //歌名

@property(nonatomic,retain)NSDictionary *user;  //用户信息

@property(nonatomic,copy)NSString *FN;  //歌曲地址

@property(nonatomic,copy)NSString *SW;  //歌词

@property(nonatomic,copy)NSString *musicUrl;

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(OneList *)oneListWithDictionary:(NSDictionary *)dictionary;

//"ID": 2996247,
//"SN": "鸾歌·《战惊天下》贰婶&小魂——天下3·战意归宗",
//"user": {
//    "ID": 4958051,
//    "NN": "鸾凤鸣原创音乐",
//    "I": "http://img4.5sing.kgimg.com/force/T1QyYbBXKT1RXrhCrK.jpg",

@end
