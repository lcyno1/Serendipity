//
//  FamousList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamousList : NSObject



@property(nonatomic,assign)NSInteger UserId;

@property(nonatomic,copy)NSString *NickName; //用户名

@property(nonatomic,copy)NSString *Portrait;  //图片地址

@property(nonatomic,assign)NSInteger Rank; //粉丝数

@property(nonatomic,retain)NSDictionary *Song;  //最新歌曲数组


@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,copy)NSString *NN;   //名字

@property(nonatomic,copy)NSString *I;   //图片地址

@property(nonatomic,assign)NSInteger YCRQ;  //关注数

@property(nonatomic,assign)NSInteger FCRQ;

@property(nonatomic,copy)NSString *M;   //描述

//@property(nonatomic,retain)NSDictionary *song;  //歌曲信息


//歌曲值
//@property(nonatomic,retain)NSString *songName;
//
//@property(nonatomic,retain)NSString *SN;


-(id)initWithDictionary:(NSDictionary *)dictionary;

+(FamousList *)famousListWithDictionary:(NSDictionary *)dictionary;
@end
