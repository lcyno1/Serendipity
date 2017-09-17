//
//  OneMusician.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneMusician : NSObject

//"ID": 50476770,
//"NN": "SeasonsForChange",
//"I": "http://img10.5sing.kgimg.com/force/T15ZJvBXxT1RXrhCrK.jpg",
//"B": "2014-05-01",
//"P": "香港",
//"C": "香港",
//"SX": 2,
//"E": "seasonsforchangehk@gmail.com",
//"M": "我们是香港另类摇滚乐队Seasons for Change
//
//"TFS": 641,
//"SC": 0,
//BG": "http://static.5sing.kugou.com/public/images/app_background_a.png",

@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,copy)NSString *NN; //用户名

@property(nonatomic,copy)NSString *I;  //头像地址

@property(nonatomic,copy)NSString *C; //所在城市

@property(nonatomic,copy)NSString *M;  //描述

@property(nonatomic,assign)NSInteger TFS; //粉丝数

@property(nonatomic,assign)NSInteger TFD;  //关注数

@property(nonatomic,assign)NSInteger SX;  //性别

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(OneMusician *)oneMusicianWithDictionary:(NSDictionary *)dictionary;


@end
