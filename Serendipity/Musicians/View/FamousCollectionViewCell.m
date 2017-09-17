//
//  FamousCollectionViewCell.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/24.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "FamousCollectionViewCell.h"
#import "FamousList.h"
#import "FamousTableViewCell.h"
#import "OneMusicianViewController.h"

@interface FamousCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FamousCollectionViewCell


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

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width , self.frame.size.height -64 - 49 ) style:UITableViewStylePlain];
    //CGRectMake(0, 64, Kwidth, Kheight - 64 - 49 )
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    [_tableView release];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"tableView";
    
    FamousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        
        cell = [[[FamousTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];////
        
    }
  
            cell.famousList =  [FamousList famousListWithDictionary: self.tableViewArray[indexPath.row]];
    


    cell.listNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 110 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OneMusicianViewController *oneView = [[OneMusicianViewController alloc]init];
    
    if ([self.tableViewArray[indexPath.row] objectForKey:@"UserId"] != nil) {
        oneView.ID = [self.tableViewArray[indexPath.row] objectForKey:@"UserId"];
    }else{
        
        oneView.ID = [self.tableViewArray[indexPath.row] objectForKey:@"ID"];
    }
    
    
    
    [self.root.navigationController pushViewController:oneView animated:YES];
    
    oneView.navigationController.navigationBar.hidden = NO;
    
    [oneView release];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
