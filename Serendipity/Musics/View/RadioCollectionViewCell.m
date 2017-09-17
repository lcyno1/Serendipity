//
//  RadioCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "RadioCollectionViewCell.h"
#import "RadioList.h"
#import "UIImageView+WebCache.h"



//屏幕宽
#define Kwidth self.view.frame.size.width
//屏幕高
#define Kheight self.view.frame.size.height

@implementation RadioCollectionViewCell

//count title desc uname coverimg

-(void)dealloc{
    
    [_count release];
    [_title release];
    [_desc release];
    [_uname release];
    [_coverimg release];
    [_countLogo release];
    [super dealloc];
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.count = [[UILabel alloc]init];
        self.count.font = [UIFont systemFontOfSize:11 * KW];
        self.count.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.count];
        [_count release];
        
        self.title = [[UILabel alloc]init];
        //self.title.textColor = [UIColor grayColor];
        self.title.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.contentView addSubview:self.title];
        [_title release];
        
        self.uname = [[UILabel alloc]init];
        self.uname.font = [UIFont systemFontOfSize:11 * KW];
        self.uname.textColor = [UIColor colorWithRed:0.4 green:0 blue:1 alpha:1];
        [self.contentView addSubview:self.uname];
        [_uname release];
        
        self.desc = [[UILabel alloc]init];
        self.desc.font = [UIFont systemFontOfSize:12 * KW];
        self.desc.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.desc];
        [_desc release];
        
        self.coverimg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.coverimg];
        [_coverimg release];
        
        
        self.countLogo = [[UIImageView alloc]init];
        [self.contentView addSubview:self.countLogo];
        [_countLogo release];
        

        

    }
    
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.coverimg.frame = CGRectMake(5 * KW, 10 * KH, 80 * KW, 80 * KH);
    
    self.title.frame = CGRectMake(90 * KW, 12 * KH, 200 * KW, 30 * KH);
    
    self.uname.frame = CGRectMake(90 * KW, 43 * KH, 200 * KW, 20 * KH);
    
    self.desc.frame = CGRectMake(90 * KW, 68 * KH, 270 * KW, 20 * KH);
    
    self.count.frame = CGRectMake(310 * KW, 10 * KH, 60 * KW, 20 * KW);
    
    self.countLogo.frame = CGRectMake(290 *KW, 12 * KH, 15 * KW, 15 * KH);
    
    
}

-(void)setRadioList:(RadioList *)radioList{
    
    
    if (_radioList != radioList) {
        
        [_radioList release];
        _radioList = [radioList retain];
        
    }
    
    
    self.count.text = [NSString stringWithFormat:@"%ld",radioList.count];
    self.title.text = radioList.title;
    self.uname.text = [NSString stringWithFormat:@"BY:  %@",[radioList.userinfo objectForKey:@"uname"] ];
    self.desc.text = radioList.desc;
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:radioList.coverimg]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    self.countLogo.image = [UIImage imageNamed:@"iconfont-laba-2"];

    
    
}


@end
