//
//  SearchTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/30.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "SearchList.h"
@implementation SearchTableViewCell

//p s u n p
-(void)dealloc{
    
    [_picture release];
    [_songName release];
    [_userName release];
    [_number release];
    [_play release];
    [super dealloc];
    
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
     
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.songName = [[UILabel alloc]init];
        [self.contentView addSubview:self.songName];
        [_songName release];
        
        self.userName = [[UILabel alloc]init];
        self.userName.font = [UIFont systemFontOfSize:13 * KW];
        self.userName.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.userName];
        [_userName release];
        
        self.number = [[UILabel alloc]init];
        self.number.font = [UIFont systemFontOfSize:13 * KW];
        self.number.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.number];
        [_number release];
        
        self.play = [[UIImageView alloc]init];
        [self.contentView addSubview:self.play];
        [_play release];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(10 * KW, 4 * KH, 40 * KW, 40 * KH);
    self.songName.frame = CGRectMake(60 * KW, 1 * KH, 250 * KW, 30 * KH);
    self.userName.frame = CGRectMake(60 * KW, 30 * KH, 150 * KW, 20 * KH);
    self.number.frame = CGRectMake(180 * KW, 30 * KH, 150 * KW, 20 * KH);
    self.play.frame = CGRectMake(330 * KW, 15 * KH, 30 * KW, 30 * KH);

    
}

-(void)setSearchList:(SearchList *)searchList{

    self.number.text = [NSString stringWithFormat:@"人气 :%ld",searchList.popularity];
    self.songName.text = searchList.songName;
    self.userName.text = searchList.singer;
    self.play.image = [UIImage imageNamed:@"iconfont-bofang"];
    self.picture.image = [UIImage imageNamed:@"iconfont-morentouxiang"];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
