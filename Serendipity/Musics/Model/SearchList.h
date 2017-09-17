//
//  SearchList.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/30.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SearchList : BaseTableViewCell
//"singer": "马頔",
//"singerId": 15520167,
//"popularity": 268845,
//"songId": 2761558,
//"type": 1,
//"songName": "南山南"
@property(nonatomic,copy)NSString *singer;

@property(nonatomic,assign)NSInteger popularity; //欢迎度

@property(nonatomic,assign)NSInteger songId;  //歌曲id

@property(nonatomic,copy)NSString *songName;

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(SearchList *)searchWithDictionary:(NSDictionary *)dictionary;



@end
