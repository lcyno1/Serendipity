//
//  CollectionTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/3.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell

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
        self.number.font = [UIFont systemFontOfSize:13 * KW];
        [self.contentView addSubview:self.number];
        [_number release];
        
        self.songName = [[UILabel alloc]init];
        self.songName.font = [UIFont systemFontOfSize:14 * KW];
        [self.contentView addSubview:self.songName];
        [_songName release];
        
//        self.userName = [[UILabel alloc]init];
//        self.userName.font = [UIFont systemFontOfSize:12 * KW];
//        self.userName.textColor = [UIColor grayColor];
//        [self.contentView addSubview:self.userName];
//        [_userName release];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.number.frame = CGRectMake(15 * KW, 10 * KH, 10 * KW, 10 * KH);
    self.songName.frame = CGRectMake(30 * KW, 8 * KH, 350 * KW, 15 * KH);
    //self.userName.frame = CGRectMake(170 * KW, 5 * KH, 100 * KW, 10 * KH);
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
