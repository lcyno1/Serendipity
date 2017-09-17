//
//  ChartsCollectionViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseCollectionViewCell.h"
@class Charts;
@interface ChartsCollectionViewCell : BaseCollectionViewCell

@property(nonatomic,retain)UILabel *title;  //表单名称

//三首歌
@property(nonatomic,retain)UILabel *songOne;

@property(nonatomic,retain)UILabel *songTwo;

@property(nonatomic,retain)UILabel *songThree;

@property(nonatomic,retain)UIImageView *picture;  //图标

@property(nonatomic,retain)UIButton *moreButton;  //更多按钮

@property(nonatomic,retain)Charts *charts;

@end
