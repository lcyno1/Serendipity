//
//  LabelLine.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/25.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "LabelLine.h"

@implementation LabelLine

-(void)dealloc{
    
    [_label release];
    [_line release];
    [super dealloc];
    
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(5 * KW, 2 * KH, 110 * KW, 12 * KH)];
        
        self.label.textColor = [UIColor grayColor];
        self.label.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.label];
        [_label release];
        
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(120 * KW, 8 * KH, self.frame.size.width - 120 * KW, 1)];
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
