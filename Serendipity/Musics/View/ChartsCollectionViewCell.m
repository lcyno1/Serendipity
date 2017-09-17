//
//  ChartsCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "ChartsCollectionViewCell.h"
#import "Charts.h"
#import "UIImageView+WebCache.h"
@implementation ChartsCollectionViewCell


-(void)dealloc{
    
    [_title release];
    [_songOne release];
    [_songTwo release];
    [_songThree release];
    [_picture release];
    [_moreButton release];
    [super dealloc];
    
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.title = [[UILabel alloc]init];
        self.title.textColor = [UIColor greenColor];
        [self.contentView addSubview:self.title];
        [_title release];
        
        
        self.songOne = [[UILabel alloc]init];
        self.songOne.font = [UIFont systemFontOfSize:13 * KW];
        [self.contentView addSubview:self.songOne];
        [_songOne release];
        
        
        self.songTwo = [[UILabel alloc]init];
        self.songTwo.font = [UIFont systemFontOfSize:13 * KW];
        [self.contentView addSubview:self.songTwo];
        [_songTwo release];
        
        
        self.songThree = [[UILabel alloc]init];
        self.songThree.font = [UIFont systemFontOfSize:13 * KW];
        [self.contentView addSubview:self.songThree];
        [_songThree release];
        
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreButton addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreButton];

        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(0, 0, 100 * KW, 100 * KH);
    
    self.title.frame = CGRectMake(110 * KW, 3 * KH, 200 * KW, 30 * KH);
    
    self.songOne.frame = CGRectMake(110 * KW, 35 * KH, 200 * KW, 20 * KH);
    
    self.songTwo.frame = CGRectMake(110 * KW, 55 * KH, 200 * KW, 20 * KH);
    
    self.songThree.frame = CGRectMake(110 * KW, 75 * KH, 200 * KW, 20 * KH);
    
    self.moreButton.frame = CGRectMake(320 * KW, 40 * KH, 20 * KW, 40 * KH);
    
    
}


-(void)setCharts:(Charts *)charts{
    
    
    if (_charts != charts) {
        
        [_charts release];
        _charts = [charts retain];
    }
    
    
    self.title.text = charts.name;
    
    //[self.picture sd_setImageWithURL:[NSURL URLWithString:charts.photo]];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:charts.photo] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    [self.moreButton setImage:[UIImage imageNamed:@"iconfont-gengduo"] forState:UIControlStateNormal];
    
    self.songOne.text = [NSString stringWithFormat:@"1.%@",charts.songs[0]];
    
    self.songTwo.text = [NSString stringWithFormat:@"2.%@",charts.songs[1]];
    
    self.songThree.text = [NSString stringWithFormat:@"3.%@",charts.songs[2]];
    
    
}


-(void)clickMore:(UIButton *)sender{
    
    NSLog(@"点击了更多");
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
