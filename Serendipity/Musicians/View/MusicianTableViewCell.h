//
//  MusicianTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseViewController.h"


@class MusicianList;
@interface MusicianTableViewCell : BaseTableViewCell

@property(nonatomic,retain)UILabel *title;

@property(nonatomic,retain)UILabel *popular;  //人气

@property(nonatomic,retain)UILabel *detail;   //描述

@property(nonatomic,retain)UILabel *newestWroks;  //最新作品

@property(nonatomic,retain)UIImageView *picture;  //头像

//@property(nonatomic,retain)UIButton *care;   //关注
//
//@property(nonatomic,retain)UIButton *play;  //播放
//
//@property(nonatomic,retain)UIButton *care1;  //关注文字;



@property(nonatomic,retain)MusicianList *musicianList;

@end
