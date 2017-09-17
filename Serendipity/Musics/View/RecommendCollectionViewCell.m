//
//  RecommendCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
#import "RecommendList.h"
#import "UIImageView+WebCache.h"

@implementation RecommendCollectionViewCell

//palyCount title picture earphone
-(void)dealloc{
    
    [_playCount release];
    [_title release];
    [_picture release];
    [_earphone release];
    [super dealloc];
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.playCount = [[UILabel alloc]init];
        self.playCount.font = [UIFont systemFontOfSize:10 * KW];
        [self.contentView addSubview:self.playCount];
        [_playCount release];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont systemFontOfSize:12 * KW];
        self.title.numberOfLines = 2;
        [self.contentView addSubview:self.title];
        [_title release];
        
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.earphone = [[UIImageView alloc]init];
        [self.contentView addSubview:self.earphone];
        [_earphone release];

        
    }
    
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.picture.frame = CGRectMake(0, 0, 95 * KW, 95 * KH);
    
    self.title.frame = CGRectMake(5 * KW, 98 * KH, 85 * KW, 30 * KH);
    
    self.earphone.frame = CGRectMake(5 * KW, 127 * KH, 16 *KW, 16 * KW);
    
    self.playCount.frame = CGRectMake(28 * KW, 126 * KH, 100 * KW, 20 * KH);

    
}

-(void)setRecommendList:(RecommendList *)recommendList{
    
    if (_recommendList != recommendList) {
        
        [_recommendList release];
        _recommendList = [recommendList retain];
        
    }
    
    
    self.title.text = recommendList.title;
    
    self.playCount.text = [NSString stringWithFormat:@"%ld",recommendList.playCount];
    
    self.earphone.image = [UIImage imageNamed:@"iconfont-tingliku"];
    
    [self.picture sd_setImageWithURL:[NSURL URLWithString:recommendList.picture]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
}


@end
