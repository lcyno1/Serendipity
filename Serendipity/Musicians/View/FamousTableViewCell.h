//
//  FamousTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class FamousList;
@interface FamousTableViewCell : BaseTableViewCell

@property(nonatomic,retain)UILabel *title;

@property(nonatomic,retain)UILabel *popular;  //人气



@property(nonatomic,retain)UILabel *newestWroks;  //最新作品

@property(nonatomic,retain)UIImageView *picture;  //头像

@property(nonatomic,retain)UIButton *care;   //关注

//@property(nonatomic,retain)UIButton *play;  //播放

@property(nonatomic,retain)UIButton *care1;  //关注文字;

@property(nonatomic,retain)UILabel *listNumber;  //排名


@property(nonatomic,retain)FamousList *famousList;
@end
