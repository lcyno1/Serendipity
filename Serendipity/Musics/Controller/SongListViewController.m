//
//  SongListViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SongListViewController.h"
#import "LCYNewWorking.h"
#import "AFNetworking.h"
#import "OneList.h"
#import "OneListTableViewCell.h"
#import "PlayingViewController.h"
#import "MJRefresh.h"
#import "MusicDatabase.h"


@interface SongListViewController ()<UITableViewDataSource,UITableViewDelegate>
//榜单字典
@property(nonatomic,retain)NSDictionary *listDic;

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *listArray;
//每个歌曲数据字典
@property(nonatomic,retain)NSDictionary *dic;

@property(nonatomic,retain)PlayingViewController *playView;

@property(nonatomic,assign)NSInteger temp;

@end

@implementation SongListViewController

-(void)dealloc{
    
    [_listDic release];
    [_type release];
    [_tableView release];
    [_listArray release];
    [_dic release];
    [_playView release];
    [super dealloc];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.listDic = [NSDictionary dictionary];
    self.listArray = [NSMutableArray array];
    self.dic = [NSDictionary dictionary];
    
    self.playView = [PlayingViewController defaultPlayingViewController];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [_tableView release];
    
    //返回按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = button;
    
    //正在播放按钮
    
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-bofangxianshi-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(nowPlay:)];
    
    self.navigationItem.rightBarButtonItem = playButton;
    
    [self webData:20];
    
    
    [self.tableView addHeaderWithCallback:^{
       
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
    }];
    
    
    self.temp = 2;
    
    [self.tableView addFooterWithCallback:^{
       
        [self webData:(20 * self.temp)];
        
        self.temp++;

        [self.tableView footerEndRefreshing];
    }];
    
    
   
    
    
}

-(void)webData:(NSInteger)dataNumber{
    
    
    //获取时间
    NSDate *nowdate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
     NSString *dataStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:nowdate]];
    
    if ([self.type isEqualToString:@"best"]) {
        
        
        NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/listbysupportcard?time=%@&limit=%ld",dataStr,dataNumber];
        
        NSString *str1 = [str stringByAppendingString:@"&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&userfields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CYCRQ%2CFCRQ%2CCC%2CBG%2CDJ%2CRC%2CMC%2CAU%2CSR%2CSG%2CVG%2CISC&maxid=0&version=5.8.2"];
        
        
        
        [LCYNewWorking GetDataWithURL:str1 dic:nil success:^(id responseObject) {
            
            //  self.listDic = [responseObject objectForKey:@"data"];
            
            self.listArray = [responseObject objectForKey:@"data"];
            
            [self titleName];
            
            self.title = @"最受欢迎的歌曲";
            
            [self.tableView reloadData];
            
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
        
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/rank/detail?id=%@&pagesize=%ld&pageindex=1&time=%@",self.type,dataNumber,dataStr];
        NSString *str1 = [str stringByAppendingString:@"&userfields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CYCRQ%2CFCRQ%2CCC%2CBG%2CDJ%2CRC%2CMC%2CAU%2CSR%2CSG%2CVG%2CISC&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&version=5.8.2"];
        
        NSLog(@"%@",str1);
        
        [LCYNewWorking GetDataWithURL:str1 dic:nil success:^(id responseObject) {
            
            self.listDic = [responseObject objectForKey:@"data"];
            
            self.listArray = [self.listDic objectForKey:@"songs"];
            
            [self titleName];
            
            [self.tableView reloadData];
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
    }
     [formatter release];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"list";
    
    OneListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[OneListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    OneList *oneList = [OneList oneListWithDictionary:self.listArray[indexPath.row]];
    
    cell.oneList = oneList;
    
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80 * KH;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
    NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/get?songtype=%@&songid=%@",[self.listArray[indexPath.row] objectForKey:@"SK"],[self.listArray[indexPath.row] objectForKey:@"ID"]];

    NSString *str1 = [str stringByAppendingString:@"&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&userfields=ID%2CNN%2CI&version=5.8.2"];

    
    [LCYNewWorking GetDataWithURL:str1 dic:nil success:^(id responseObject) {

        self.dic = [responseObject objectForKey:@"data"];
        
        self.playView.musicUrl = [self.dic objectForKey:@"FN"];
        
        self.playView.user = [self.dic objectForKey:@"user"];
        
        self.playView.SW = [self.dic objectForKey:@"SW"];
        
        self.playView.SN = [self.dic objectForKey:@"SN"];
        
        [self.navigationController pushViewController:self.playView animated:YES];
        
        [self.tableView reloadData];
    
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}



//设置标题
-(void)titleName{
    
    UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = [self.listDic objectForKey:@"name"];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
    
}
//返回按钮
-(void)cancel:(UIBarButtonItem *)sender{
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
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
