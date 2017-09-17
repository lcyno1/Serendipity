//
//  FamousCollectionViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BaseViewController.h"


@interface FamousCollectionViewCell : BaseCollectionViewCell

@property(nonatomic,retain)UITableView *tableView;

//tableView数据的数组
@property(nonatomic,retain)NSMutableArray *tableViewArray;

@property(nonatomic,retain)BaseViewController *root;

@end
