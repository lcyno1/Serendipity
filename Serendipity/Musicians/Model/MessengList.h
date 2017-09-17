//
//  MessengList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/27.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessengList : NSObject


@property(nonatomic,copy)NSString *content; //评论

@property(nonatomic,copy)NSString *createTime; //评论时间

@property(nonatomic,retain)NSDictionary *user; //评论用户

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(MessengList *)messengListWithDictionary:(NSDictionary *)dictionary;

@end
