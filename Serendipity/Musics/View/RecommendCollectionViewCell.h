//
//  RecommendCollectionViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//   歌单界面

#import "BaseCollectionViewCell.h"
@class RecommendList;
@interface RecommendCollectionViewCell : BaseCollectionViewCell

@property(nonatomic,retain)UILabel *playCount;   //播放数

@property(nonatomic,retain)UILabel *title;       //标题

@property(nonatomic,retain)UIImageView *picture; //图片

@property(nonatomic,retain)UIImageView *earphone;  //耳机图片

@property(nonatomic,retain)RecommendList *recommendList; 

@end
