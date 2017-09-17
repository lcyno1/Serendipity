//
//  MusicianCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/23.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusicianCollectionViewCell.h"
#import "MusicianTableViewCell.h"
#import "MusicianList.h"
#import "OneMusicianViewController.h"
#import "MusicianViewController.h"

@interface MusicianCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MusicianCollectionViewCell

-(void)dealloc{
    
    [_tableView release];
    [_tableViewArray release];
    [_root release];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width , self.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    //CGRectMake(0, 64, Kwidth, Kheight - 64 - 49 )
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    [_tableView release];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"tableView";
    
    MusicianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        
        cell = [[[MusicianTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease]; ////
        
    }
    

    
    cell.musicianList =  [MusicianList musicianListWitnDictionary:self.tableViewArray[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 125 * KH;
}

#pragma mark 点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OneMusicianViewController *oneView = [[OneMusicianViewController alloc]init];
    
    oneView.ID = [self.tableViewArray[indexPath.row] objectForKey:@"ID"];
   
    [self.root.navigationController pushViewController:oneView animated:YES];
    
    oneView.navigationController.navigationBar.hidden = NO;
    
    [oneView release];
    
}




@end
