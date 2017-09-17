//
//  SongListCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SongListCollectionViewCell.h"
#import "SongList.h"
#import "UIImageView+WebCache.h"

@implementation SongListCollectionViewCell

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
    
    //cell宽 355/2=177.5  120
    self.picture.frame = CGRectMake(0, 0, 168 * KW, 120 * KH);
    
    self.title.frame = CGRectMake(5 * KW, 123 * KH, 160 * KW, 30 * KH);
    
    self.earphone.frame = CGRectMake(5 * KW, 145 * KH, 18 *KW, 18 * KW);
    
    self.playCount.frame = CGRectMake(28 * KW, 147 * KH, 100 * KW, 20 * KH);
    
    
}

-(void)setSongList:(SongList *)songList{
    
    
    if (_songList != songList) {
        
        [_songList release];
        _songList = [songList retain];
    }
    
    
    self.title.text = songList.T;
    self.playCount.text = [NSString stringWithFormat:@"%@",songList.H];
    self.earphone.image = [UIImage imageNamed:@"iconfont-tingliku"];
    
    [self.picture sd_setImageWithURL:[NSURL URLWithString:songList.P]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];

    
    
    
    
    
}




@end
