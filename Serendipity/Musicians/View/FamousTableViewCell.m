//
//  FamousTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "FamousTableViewCell.h"
#import "FamousList.h"
#import "UIImageView+WebCache.h"
@implementation FamousTableViewCell


-(void)dealloc{
    
    [_title release];
    [_popular release];
    [_listNumber release];
    [_newestWroks release];
    [_picture release];
//    [_care release];
//    [_play release];
//    [_care1 release];
    [super dealloc];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        [_title release];
        
        self.popular = [[UILabel alloc]init];
        self.popular.font = [UIFont systemFontOfSize:12 * KW];
        self.popular.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.popular];
        [_popular release];
        
        
        self.newestWroks = [[UILabel alloc]init];
        self.newestWroks.font = [UIFont systemFontOfSize:13 * KW];
        self.newestWroks.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.newestWroks];
        [self.newestWroks release];
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
//        self.play = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.play addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.play];
//        [_play release];
        
//        self.care = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.care addTarget:self action:@selector(clickCare:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.care];
//        [_care release];
//        
//        self.care1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.care1 addTarget:self action:@selector(clickCare:) forControlEvents:UIControlEventTouchUpInside];
//        self.care1.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:self.care1];
//        [_care1 release];
        
        self.listNumber = [[UILabel alloc]init];
        self.listNumber.font = [UIFont systemFontOfSize:35];
        if ([self.listNumber.text integerValue] < 4) {
            self.listNumber.textColor = [UIColor redColor];
        }
        [self.contentView addSubview:self.listNumber];
        [_listNumber release];
        
    }
    
    return self;
}


-(void)layoutSubviews{
    //130
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(45 * KW, 10 * KH, 80 * KW, 80 * KW);
    self.picture.layer.cornerRadius = 40 * KW;
    self.picture.layer.masksToBounds = YES;
    
    self.title.frame = CGRectMake(140 * KW, 10 * KH, 200 * KW, 40 * KH);
    
    self.popular.frame = CGRectMake(140 * KW, 60 * KH, 150 * KW, 25 * KH);
    
    
    //self.care.frame = CGRectMake(300 * KW, 20 * KH, 30 * KW, 40 * KH);
    
    //self.care1.frame = CGRectMake(295 * KW, 58 * KH, 40 * KW, 20 * KH);
    
    self.newestWroks.frame = CGRectMake(25 * KW, 108 * KH, 250 * KW, 20 * KH);
    
    //self.play.frame = CGRectMake(308 * KW, 108 * KH, 18 * KW, 17 * KH);
    
    self.listNumber.frame = CGRectMake(5 * KW, 40 * KH, 40 * KW, 30 * KH);
    
}

-(void)setFamousList:(FamousList *)famousList{
    
    if (_famousList != famousList) {
        
        [_famousList release];
        _famousList = [famousList retain];
    }
    if (famousList.NickName != nil) {
        self.title.text = famousList.NickName;
    }else{
         self.title.text = famousList.NN;
    }
    
    if (famousList.Rank != 0) {
        self.popular.text = [NSString stringWithFormat:@"人气: %ld",famousList.Rank];

    }else{
        self.popular.text = [NSString stringWithFormat:@"人气: %ld",famousList.YCRQ];
    }
    
    
    ///////////////////
//    if (famousList.songName != nil) {
//       self.newestWroks.text = [NSString stringWithFormat:@"最新作品 :%@",famousList.songName];
//    }
//    else if(famousList.SN != nil){
//        self.newestWroks.text = [NSString stringWithFormat:@"最新作品 :%@",famousList.SN];
//    }
    //////////////////
    
    
    
    
    if (famousList.Portrait != nil) {
       // [self.picture sd_setImageWithURL:[NSURL URLWithString:famousList.Portrait]];
        [self.picture sd_setImageWithURL:[NSURL URLWithString:famousList.Portrait] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];

    }else{
        
        //[self.picture sd_setImageWithURL:[NSURL URLWithString:famousList.I]];
        [self.picture sd_setImageWithURL:[NSURL URLWithString:famousList.I] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    }
    
    //[self.play setImage:[UIImage imageNamed:@"iconfont-bofang-3"] forState:UIControlStateNormal];
    //[self.care setImage:[UIImage imageNamed:@"iconfont-guanzhu-2"] forState:UIControlStateNormal];
    //[self.care1 setTitle:@"关注" forState:UIControlStateNormal];
    //[self.care1 setTitleColor:[UIColor colorWithRed:0 green:0.9 blue:0 alpha:1] forState:UIControlStateNormal];

    
    
}


-(void)clickPlay:(UIButton *)sender{
    
    NSLog(@"点击了播放");
    
}


-(void)clickCare:(UIButton *)sender{
    
    
    NSLog(@"点击了关注");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
