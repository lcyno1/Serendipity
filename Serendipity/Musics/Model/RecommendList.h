//
//  RecommendList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

 乐库推荐页 推荐歌单类
 
*/

@interface RecommendList : NSObject
@property(nonatomic,assign)NSInteger playCount;   //播放次数

@property(nonatomic,copy)NSString *title;         //标题

@property(nonatomic,copy)NSString *picture;       //图标地址

@property(nonatomic,copy)NSString *songListId;    //歌单id



//初始化方法
-(id)initWithDictionary:(NSDictionary *)dictionary;

//便利构造器
+(RecommendList *)recommendListWithDictionary:(NSDictionary *)dictionary;




@end
