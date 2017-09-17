//
//  RadioList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RadioList : NSObject

/*
 
 乐库推荐页 推荐电台类
 
 */
@property(nonatomic,assign)NSInteger count;   //收听数

@property(nonatomic,copy)NSString *desc;      //描述

@property(nonatomic,copy)NSString *radioid;   //电台id;

@property(nonatomic,copy)NSString *title;     //电台名

@property(nonatomic,copy)NSString *coverimg;  //图标地址

@property(nonatomic,retain)NSDictionary *userinfo;   //用户信息

-(id)initWithDcitionary:(NSDictionary *)dictionary;

+(RadioList *)radioListWithDcitionary:(NSDictionary *)dictionary;


@end
