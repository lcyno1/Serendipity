//
//  OneListTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneListTableViewCell.h"
#import "OneList.h"
#import "UIImageView+WebCache.h"


@implementation OneListTableViewCell

-(void)dealloc{
    
    [_songName release];
    [_userName release];
    [_number release];
    [_picture release];
    [_play release];
    [super dealloc];
    
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.songName = [[UILabel alloc]init];
        [self.contentView addSubview:self.songName];
        [_songName release];
        
        self.userName = [[UILabel alloc]init];
        self.userName.font = [UIFont systemFontOfSize:13 * KW];
        self.userName.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.userName];
        [_userName release];
        
        self.number = [[UILabel alloc]init];
        self.number.font = [UIFont systemFontOfSize:25 * KW];
        [self.contentView addSubview:self.number];
        [_number release];
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.play = [[UIImageView alloc]init];
        [self.contentView addSubview:self.play];
        [_play release];
        
        
    }
    
    
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.number.frame = CGRectMake(10 * KW, 23 * KH, 40 * KW, 20 * KH);
    
    self.picture.frame = CGRectMake(45 * KW, 15 * KH, 40 * KW, 40 * KH);
    self.picture.layer.cornerRadius = 7 * KW;
    self.picture.layer.masksToBounds = YES;
    
    self.songName.frame = CGRectMake(95 * KW, 10 * KH, 240 * KW, 30 * KH);
    self.userName.frame = CGRectMake(95 * KW, 40 * KH, 200 * KW, 20 * KH);
    self.play.frame = CGRectMake(330 * KW, 15 * KW, 30 * KW, 30 * KH);
    
    
}

-(void)setOneList:(OneList *)oneList{
    
    if (_oneList != oneList) {
        
        [_oneList release];
        _oneList = [oneList retain];
        
    }
    
    self.songName.text = oneList.SN;
    self.play.image = [UIImage imageNamed:@"iconfont-bofang"];
    self.userName.text = [oneList.user objectForKey:@"NN"];
    //[self.picture sd_setImageWithURL:[NSURL URLWithString:[oneList.user objectForKey:@"I"]]];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:[oneList.user objectForKey:@"I"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
