//
//  MusicListTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "OneList.h"
@implementation MusicListTableViewCell

-(void)dealloc{
    
    [_songName release];
    [_userName release];
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
        self.userName.font = [UIFont systemFontOfSize:14.5 * KW];
        self.userName.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.userName];
        [_userName release];
        
        
        self.play = [[UIImageView alloc]init];
        [self.contentView addSubview:self.play];
        [_play release];
        
        
    }
    
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.songName.frame = CGRectMake(20 * KW, 10 * KH, 300 * KW, 30 * KH);
    self.userName.frame = CGRectMake(20 * KW, 37 * KH, 200 * KW, 20 * KH);
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
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
