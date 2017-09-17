//
//  WorkList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkList : NSObject

//"ID": 2942608,
//"SN": "风起琅琊",
//"FN": "http://data1.5sing.kgimg.com/T19ixvByDT1R47IVrK.mp3",
//"SK": "yc",
//"SW": "
@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,copy)NSString *SN; //歌名

@property(nonatomic,copy)NSString * FN; // 歌曲地址

@property(nonatomic,copy)NSString *SW;  //歌词

@property(nonatomic,retain)NSDictionary *user;  //作者

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(WorkList *)workListWithDictionary:(NSDictionary *)dictionary;


@end
