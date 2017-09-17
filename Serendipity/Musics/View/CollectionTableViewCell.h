//
//  CollectionTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 16/1/3.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CollectionTableViewCell : BaseTableViewCell
//序号
@property(nonatomic,retain)UILabel *number;

@property(nonatomic,retain)UILabel *songName;

@property(nonatomic,retain)UILabel *userName;

@end
