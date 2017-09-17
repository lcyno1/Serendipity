//
//  MineTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/8.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

-(void)dealloc{
    
    [_picture release];
    [_titleLabel release];
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:18 * KW];
        [self.contentView addSubview:self.titleLabel];
        [_titleLabel release];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(18 * KW, 10 * KH, 40 * KW, 40 * KH);
    self.titleLabel.frame = CGRectMake(80 * KW, 10 * KH, 200 * KW, 40 * KH);
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
