//
//  OneMusicianCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/26.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneMusicianCell.h"
#import "WorkListTableViewCell.h"
#import "WorkList.h"
#import "PlayingViewController.h"

@interface OneMusicianCell ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation OneMusicianCell



-(void)dealloc{
    
    [_tableView release];
    [_tableViewArray release];
    [super dealloc];
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self createTableView];
        
        self.tableViewArray = [NSMutableArray array];
        
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
    
    static NSString *indentify = @"workList";
    
    WorkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[WorkListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    WorkList *workList = [WorkList workListWithDictionary:self.tableViewArray[indexPath.row]];
    
    
    cell.workList = workList;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50 * KH;
}

#pragma mark 点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

//    PlayingViewController *playView = [[PlayingViewController alloc]init];
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];

    playView.musicUrl = [self.tableViewArray[indexPath.row] objectForKey:@"FN"];
    
    playView.user = [self.tableViewArray[indexPath.row]objectForKey:@"user"];
    
    playView.SW = [self.tableViewArray[indexPath.row] objectForKey:@"SW"];
    
    playView.SN = [self.tableViewArray[indexPath.row] objectForKey:@"SN"];
    
    [self.navigationController pushViewController:playView animated:YES];
    
//    [playView release];
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
