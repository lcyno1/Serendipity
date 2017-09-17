//
//  ProjectList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/22.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectList : NSObject

/*
 
 乐库推荐页 专题类
 
 */

@property(nonatomic,assign)NSInteger Id;

@property(nonatomic,copy)NSString *Title;

@property(nonatomic,copy)NSString *Url;    //专题地址

@property(nonatomic,copy)NSString *ImgUrl;   //专题图片

@property(nonatomic,assign)NSInteger CreateTime;  //创建时间

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(ProjectList *)projectListWithDictionary:(NSDictionary *)dictionary;




@end
