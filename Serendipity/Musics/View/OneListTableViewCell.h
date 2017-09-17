//
//  OneListTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//  具体歌单的tableView

#import "BaseTableViewCell.h"
@class OneList;
@interface OneListTableViewCell : BaseTableViewCell

@property(nonatomic,retain)UILabel *songName;

@property(nonatomic,retain)UILabel *userName;

@property(nonatomic,retain)UIImageView *picture;  //头像

@property(nonatomic,retain)UILabel *number;  //排名

@property(nonatomic,retain)UIImageView *play;  //播放

@property(nonatomic,retain)OneList *oneList;


@end
