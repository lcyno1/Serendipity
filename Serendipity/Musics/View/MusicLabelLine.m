//
//  MusicLabelLine.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/25.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusicLabelLine.h"

@implementation MusicLabelLine

-(void)dealloc{
    
    [_label release];
    [_line release];
    [super dealloc];
    
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(18 * KW, 2 * KH, 80 * KW, 20 * KH)];
        
        self.label.textColor = [UIColor grayColor];
        self.label.font = [UIFont systemFontOfSize:14 * KW];
        self.label.textColor = [UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1];
        [self addSubview:self.label];
        [_label release];
        
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(85 * KW, 13 * KH, self.frame.size.width - 85 * KW, 1)];
        self.line.backgroundColor = [UIColor grayColor];
        [self addSubview:self.line];
        [_line release];
  
        
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
