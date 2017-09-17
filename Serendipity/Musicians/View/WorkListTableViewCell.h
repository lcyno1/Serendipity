//
//  WorkListTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class WorkList;
@interface WorkListTableViewCell : BaseTableViewCell

//26238718

@property(nonatomic,retain)UILabel *title; //歌名

@property(nonatomic,retain)UILabel *time;

@property(nonatomic,retain)UIImageView *play;

@property(nonatomic,retain)WorkList *workList;
@end
