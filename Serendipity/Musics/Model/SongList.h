//
//  SongList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongList : NSObject

//歌单页面类


@property(nonatomic,retain)NSString *ID;

@property(nonatomic,retain)NSString *T;  //标题

@property(nonatomic,retain)NSString *P;  //图片地址

@property(nonatomic,assign)NSString *H;   //收听人数;

//初始化方法
-(id)initWithDictionary:(NSDictionary *)dictionary;

//便利构造器
+(SongList *)songListWithDictionary:(NSDictionary *)dictionary;

@end
