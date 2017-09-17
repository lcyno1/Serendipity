//
//  ProjectTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/22.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class ProjectList;
@interface ProjectTableViewCell : BaseTableViewCell

/*
"Id": 118708,
"Title": "谁说我们没有摇滚？！",
"Url": "http://5sing.kugou.com/hd/musicman/rock",
"ImgUrl": "http://img5.5sing.kgimg.com/m/T1OrdvByVT1RXrhCrK.jpg",
"CreateTime": 1447689600
*/

@property(nonatomic,retain)UILabel *createTime;  //专题id

@property(nonatomic,retain)UILabel *title;  //标题

@property(nonatomic,retain)UIImageView *picture;  //专题图片

@property(nonatomic,retain)UIImageView *more;   //更多图标;

@property(nonatomic,retain)ProjectList *projectList;


@end
