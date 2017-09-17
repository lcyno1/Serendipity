//
//  MusicListTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class OneList;
@interface MusicListTableViewCell : BaseTableViewCell

@property(nonatomic,retain)UILabel *songName;

@property(nonatomic,retain)UILabel *userName;

@property(nonatomic,retain)UIImageView *play;

@property(nonatomic,retain)OneList *oneList;
@end
