//
//  OneRadioTableView.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/6.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "OneRadioTableView.h"
#import "UIImageView+WebCache.h"

@implementation OneRadioTableView

-(void)dealloc{
    
    [_numberLabel release];
    [_titleLabel release];
    [_picture release];
    [_play release];
    [_lb release];
    [super dealloc];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        [_titleLabel release];
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.font = [UIFont systemFontOfSize:12 * KW];
        self.numberLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.numberLabel];
        [_numberLabel release];
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.play = [[UIImageView alloc]init];
        self.play.image = [UIImage imageNamed:@"iconfont-bofangPK"];
        [self.contentView addSubview:self.play];
        [_play release];
        
        self.lb = [[UIImageView alloc]init];
        self.lb.image = [UIImage imageNamed:@"iconfont-laba"];
        [self.contentView addSubview:self.lb];
        [_lb release];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    
    
    self.picture.frame = CGRectMake(5 * KW, 5 * KH, 36 * KW, 36 * KH);
    self.titleLabel.frame = CGRectMake(50 * KW, 2 * KH, 280 * KW, 30 * KH);
    self.lb.frame = CGRectMake(50 * KW, 30 * KH, 15 * KW, 15 * KH);
    self.numberLabel.frame = CGRectMake(65 * KW, 27.5 * KH, 100 * KW, 20 * KH);
    self.play.frame = CGRectMake(290 * KW, 10 * KH, 30 * KW, 30 * KH);
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
