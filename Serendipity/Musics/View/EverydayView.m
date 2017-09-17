//
//  EverydayView.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/20.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "EverydayView.h"
#import "PrefixHeader.pch"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高



@implementation EverydayView

-(void)dealloc{
    
    [_titleLabel release];
    [_recommendWords release];
    [_Picture release];
    [super dealloc];
    
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.Picture = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 90 *KW, 90 * KH)];
        [self addSubview:self.Picture];
        [_Picture release];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.Picture.frame.size.width + 15, 10 * KH, 200 * KH, 30 * KW)];
        self.titleLabel.font = [UIFont systemFontOfSize:20 * KW];
        [self addSubview:self.titleLabel];
        [_titleLabel release];
        
        self.recommendWords = [[UILabel alloc]initWithFrame:CGRectMake(self.Picture.frame.size.width + 15, 30 * KH, 250 * KW, 60 * KH)];
        self.recommendWords.numberOfLines = 2;
        self.recommendWords.font = [UIFont systemFontOfSize:14 * KW];
        self.recommendWords.textColor = [UIColor grayColor];
        [self addSubview:self.recommendWords];
        [_recommendWords release];
        
        
        
    }
    
    return self;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
