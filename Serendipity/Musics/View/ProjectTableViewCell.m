//
//  ProjectTableViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/22.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "ProjectList.h"
#import "UIImageView+WebCache.h"



@implementation ProjectTableViewCell

-(void)dealloc{
    
    [_title release];
    [_createTime release];
    [_picture release];
    [_more release];
    [super dealloc];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        [_title release];
        
        self.createTime = [[UILabel alloc]init];
        self.createTime.font = [UIFont systemFontOfSize:12];
        self.createTime.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.createTime];
        [_createTime release];
        
        self.picture = [[UIImageView alloc]init];
        [self.contentView addSubview:self.picture];
        [_picture release];
        
        self.more = [[UIImageView alloc]init];
        [self.contentView addSubview:self.more];
        [_more release];
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    
    [super layoutSubviews];
    
    self.picture.frame = CGRectMake(5 * KW, 10 * KH, 85 * KW, 85 * KH);
    
    self.title.frame = CGRectMake(100 * KW, 17 * KH, 200 * KW, 30 * KH);
    
    self.createTime.frame = CGRectMake(105 * KW, 55 * KH, 200 * KW, 20 * KH);
    
    self.more.frame = CGRectMake(330 * KW, 40 * KH, 25 * KW, 25 * KH);
    
}

-(void)setProjectList:(ProjectList *)projectList{
    
    if (_projectList != projectList) {
        
        [_projectList release];
        
        _projectList = [projectList retain];
    }
    
    
    self.title.text = projectList.Title;
    
    self.createTime.text = [NSString stringWithFormat:@"%ld",projectList.CreateTime];
    
    [self.picture sd_setImageWithURL:[NSURL URLWithString:projectList.ImgUrl]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateLoca = [NSString stringWithFormat:@"%ld",projectList.CreateTime];
    NSTimeInterval time=[dateLoca doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestr = [formatter stringFromDate:detaildate];
    
    self.createTime.text = timestr;
    
    self.more.image = [UIImage imageNamed:@"iconfont-gengduo"];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
