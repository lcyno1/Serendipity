//
//  MessengCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/27.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MessengCollectionViewCell.h"
#import "MessengList.h"
#import "MessengTableViewCell.h"

@interface MessengCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation MessengCollectionViewCell

-(void)dealloc{
    
    [_tableView release];
    [_tableViewArray release];
    [super dealloc];

}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.tableViewArray = [NSMutableArray array];
        
        [self createTableView];
        
        
    }
    
    return self;
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height  ) style:UITableViewStylePlain];
    //CGRectMake(0, 64, Kwidth, Kheight - 64 - 49 )
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    [_tableView release];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"messeng";
    
    MessengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[MessengTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
   
    
    //数据多了一层comments
    
    NSArray *array = [self.tableViewArray[indexPath.row] objectForKey:@"comments"] ;
    
    NSDictionary *dic = array.firstObject;
    
    MessengList *messengList = [MessengList messengListWithDictionary:dic];
    
    //出现问题
    cell.messengList = messengList;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *array = [self.tableViewArray[indexPath.row] objectForKey:@"comments"] ;
    
    NSDictionary *dic = array.firstObject;
    
    MessengList *messengList = [MessengList messengListWithDictionary:dic];
    
    CGFloat result = [MessengTableViewCell HeightOfSuit:messengList.content font:[UIFont systemFontOfSize:13] width:self.frame.size.width - 30 * KW * 2];
    
    CGFloat single = [MessengTableViewCell HeightOfSuit:@"s" font:[UIFont systemFontOfSize:13] width:self.frame.size.width - 30 * KW * 2];
    
    
    return result - single + 80 * KH;
}

#pragma mark 点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
