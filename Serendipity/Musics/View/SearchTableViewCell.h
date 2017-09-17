//
//  SearchTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/30.
//  Copyright © 2015年 李重阳. All rights reserved.
//  搜索结果列表

#import "BaseTableViewCell.h"
@class SearchList;
@interface SearchTableViewCell : BaseTableViewCell
//头像
@property(nonatomic,retain)UIImageView *picture;
//歌名
@property(nonatomic,retain)UILabel *songName;
//作者
@property(nonatomic,retain)UILabel *userName;
//人气
@property(nonatomic,retain)UILabel *number;
//播放图片
@property(nonatomic,retain)UIImageView *play;

@property(nonatomic,retain)SearchList *searchList;
@end
