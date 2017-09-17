//
//  MoreProjectViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/25.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MoreProjectViewController.h"
#import "MusicViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectList.h"
#import "LCYNewWorking.h"
#import "AFNetworking.h"
#import "OneProViewController.h"
#import "MJRefresh.h"
#import "PlayingViewController.h"
#import "MusicDatabase.h"

@interface MoreProjectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *listArray;

@end

@implementation MoreProjectViewController

-(void)dealloc{
    
    [_tableView release];
    [_listArray release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray = [NSMutableArray array];
    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(153 * KW, 12 * KH, 200 * KW, 20 * KH)];
//    titleLabel.textColor = [UIColor greenColor];
//    titleLabel.text = @"全部专题";
//    titleLabel.textColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
//    [self.navigationController.navigationBar addSubview:titleLabel];
//    [titleLabel release];
    
    //选择自己喜欢的颜色
    UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = @"全部专题";
    
    //返回按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = button;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView addHeaderWithCallback:^{
       
        NSLog(@"asdasdasasdasd");
        [self.tableView headerEndRefreshing];
    }];
    
    [self.tableView addFooterWithCallback:^{
      
        [self.tableView footerEndRefreshing];
    }];
    
    
    //请求数据
    
    NSString *str = @"http://goapi.5sing.kugou.com/getTheme?t=101&o1=1&o2=20&tag=66&version=5.8.2";
    
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.listArray = [responseObject objectForKey:@"data"];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
       
        NSLog(@"%@",error);
        
    }];
    
    
    
    [self.view addSubview:self.tableView];
    [_tableView release];
    
}


//返回按钮方法
-(void)cancel:(UIBarButtonItem *)sender{
    
    MusicViewController *musicView = [[MusicViewController alloc]init];
    
    musicView.navigationController.navigationBar.hidden = YES;
    
    [self.navigationController pushViewController:musicView animated:YES];
    
    [musicView release];
}

//正在播放按钮
-(void)nowPlay:(UIBarButtonItem *)sender{
    
    MusicDatabase *dataBase = [MusicDatabase musicDatabase];
    
    NSArray *array = [NSArray array];
    
    array = [dataBase historyAllMusic];
    if (array.count != 0) {
        PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
        
        [self.navigationController pushViewController:playView animated:YES];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏~" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
}

#pragma mark tableView单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

#pragma mark 自定义tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *indentify = @"project";
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        
        cell = [[[ProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];////
        
    }
    
    ProjectList *project = [ProjectList projectListWithDictionary:self.listArray[indexPath.row]];
    
    cell.projectList = project;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 110 * KH;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OneProViewController *oneView = [[OneProViewController alloc]init];
    
    oneView.nameTitle = [self.listArray[indexPath.row] objectForKey:@"Title"];
    
    oneView.urlStr = [self.listArray[indexPath.row] objectForKey:@"Url"];
    
    [self.navigationController pushViewController:oneView animated:YES];
    
    [oneView release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
