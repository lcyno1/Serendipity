//
//  MineSongTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/8.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "MineSongTableViewCell.h"

@implementation MineSongTableViewCell

-(void)dealloc{
    
    [_number release];
    [_songName release];
    [_userName release];
    [super dealloc];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
     
        self.number = [[UILabel alloc]init];
        self.number.font = [UIFont systemFontOfSize:20 * KW];
        [self.contentView addSubview:self.number];
        [_number release];
        
        self.songName = [[UILabel alloc]init];
        self.songName.font = [UIFont systemFontOfSize:16 * KW];
        [self.contentView addSubview:self.songName];
        [_songName release];
        
        self.userName = [[UILabel alloc]init];
        self.userName.font = [UIFont systemFontOfSize:14 * KW];
        //self.userName.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.userName];
        [_userName release];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.number.frame = CGRectMake(20 * KW, 12 * KH, 30 * KW, 30 * KH);
    self.songName.frame = CGRectMake(45 * KW, 0 * KH, 300 * KW, 40 * KH);
    self.userName.frame = CGRectMake(45 * KW, 24 * KH, 200 * KW, 30 * KH);
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
