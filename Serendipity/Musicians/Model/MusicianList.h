//
//  MusicianList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicianList : NSObject

/*
 "ID": 50476770,
 "follow": 0,
 "NN": "SeasonsForChange",
 "I": "http://img10.5sing.kgimg.com/force/T15ZJvBXxT1RXrhCrK.jpg",
 "TFS": 552,
 "YCRQ": 1026723,
 "FCRQ": 90471,
 "M": "香港另类摇滚乐队",
 "Song": {
 "ID": 142
 */

@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,copy)NSString *NN;   //名字

@property(nonatomic,copy)NSString *I;   //图片地址

@property(nonatomic,assign)NSInteger YCRQ;  //关注数

@property(nonatomic,assign)NSInteger FCRQ;

@property(nonatomic,copy)NSString *M;   //描述

@property(nonatomic,retain)NSDictionary *song;  //歌曲信息

-(id)initWitnDictionary:(NSDictionary *)dictionary;

+(MusicianList *)musicianListWitnDictionary:(NSDictionary *)dictionary;


@end
