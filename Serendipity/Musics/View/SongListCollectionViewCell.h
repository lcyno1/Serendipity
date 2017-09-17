//
//  SongListCollectionViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseCollectionViewCell.h"
@class SongList;
@interface SongListCollectionViewCell : BaseCollectionViewCell


@property(nonatomic,retain)UILabel *playCount;   //播放数

@property(nonatomic,retain)UILabel *title;       //标题

@property(nonatomic,retain)UIImageView *picture; //图片

@property(nonatomic,retain)UIImageView *earphone;  //耳机图片

@property(nonatomic,retain)SongList *songList;
@end
