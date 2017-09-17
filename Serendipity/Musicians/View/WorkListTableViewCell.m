//
//  WorkListTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "WorkListTableViewCell.h"
#import "WorkList.h"


@implementation WorkListTableViewCell

-(void)dealloc{
    
    [_title release];
    [_play release];
    [_time release];
    [super dealloc];
    
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont systemFontOfSize:17 * KW];
        [self.contentView addSubview:self.title];
        [_title release];
        
        self.play = [[UIImageView alloc]init];
        [self.contentView addSubview:self.play];
        [_play release];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(5 * KW, 15 * KH, 280 * KW, 20 * KH);
    self.play.frame = CGRectMake(310 * KW, 8 * KH, 30 * KW, 30 * KH);
    
}

-(void)setWorkList:(WorkList *)workList{
    
    self.title.text = workList.SN;
    
    self.play.image = [UIImage imageNamed:@"iconfont-bofang"];
    
}


@end
