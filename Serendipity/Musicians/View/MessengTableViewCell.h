//
//  MessengTableViewCell.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/27.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class MessengList;
@interface MessengTableViewCell : BaseTableViewCell

@property(nonatomic,retain)UIImageView *picture; //头像

@property(nonatomic,retain)UILabel *userName;

@property(nonatomic,retain)UILabel *content;    //评论

@property(nonatomic,retain)UILabel *createTime; //评论时间
//content createTime
@property(nonatomic,retain)MessengList *messengList;

+(CGFloat)HeightOfSuit:(NSString *)text font:(UIFont *)font width:(CGFloat)width;


@end
