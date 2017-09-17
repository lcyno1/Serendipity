//
//  RadioCollectionViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class RadioList;

@interface RadioCollectionViewCell : BaseCollectionViewCell 


@property(nonatomic,retain)UILabel *count;  //听众数

@property(nonatomic,retain)UILabel *title;

@property(nonatomic,retain)UILabel *desc;   //细节描述

@property(nonatomic,retain)UILabel *uname;  //用户名

@property(nonatomic,retain)UIImageView *coverimg;  //电台图标

@property(nonatomic,retain)UIImageView *countLogo;  //喇叭图标

@property(nonatomic,retain)RadioList *radioList;

@end