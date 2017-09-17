//
//  MessengTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/27.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MessengTableViewCell.h"
#import "MessengList.h"
#import "UIImageView+WebCache.h"

@implementation MessengTableViewCell

-(void)dealloc{
    
    [_picture release];
    [_userName release];
    [_createTime release];
    [_content release];
    [super dealloc];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.userName = [[UILabel alloc]init];
        self.userName.textColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
        self.userName.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.userName];
        [_userName release];
        
        self.content = [[UILabel alloc]init];
        self.content.font = [UIFont systemFontOfSize:13];
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        [_content release];
        
        self.createTime = [[UILabel alloc]init];
        self.createTime.font = [UIFont systemFontOfSize:12];
        self.createTime.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.createTime];
        [_createTime release];
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(3 * KW, 7 * KH, 30 * KW, 30 *KH);
    self.picture.layer.cornerRadius = 15;
    self.picture.layer.masksToBounds = YES;
    
    self.userName.frame = CGRectMake(45 * KW, 10 * KH, 150 * KW, 20 * KH);
    self.createTime.frame = CGRectMake(45 * KW, 30 * KH, 80 * KW, 15 * KH);

    CGFloat contentHeight = [MessengTableViewCell HeightOfSuit:self.messengList.content font:self.content.font width:self.frame.size.width - 30 *KW * 2];
    
    self.content.frame = CGRectMake(45 * KW, 50 * KH, self.frame.size.width - 30 *KW * 2, contentHeight);
    
    
}

-(void)setMessengList:(MessengList *)messengList{
    
    if (_messengList != messengList) {
        
        [_messengList release];
        _messengList  = [messengList retain];
    }

    self.userName.text = [messengList.user objectForKey:@"NN"];
    self.createTime.text = messengList.createTime;
    self.content.text = messengList.content;
    
    //[self.picture sd_setImageWithURL:[NSURL URLWithString:[messengList.user objectForKey:@"I"]]];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:[messengList.user objectForKey:@"I"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];

    
}




+(CGFloat)HeightOfSuit:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    NSDictionary *style = [[NSDictionary alloc]initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    CGRect result = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
    
    return result.size.height;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
