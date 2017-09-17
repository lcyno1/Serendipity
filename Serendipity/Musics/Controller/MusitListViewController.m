//
//  MusitListViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusitListViewController.h"
#import "LCYNewWorking.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MusicListTableViewCell.h"
#import "OneList.h"
#import "PlayingViewController.h"
#import "MusicDatabase.h"



#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface MusitListViewController ()<UITableViewDataSource,UITableViewDelegate>
//头视图字典
@property(nonatomic,retain)NSDictionary *headDic;
//全部歌曲
@property(nonatomic,retain)NSMutableArray *songArray;
//头视图底图
@property(nonatomic,retain)UIView *myview;

@property(nonatomic,retain)UITableView *tableView;

//@property(nonatomic,retain)MBProgressHUD *hotWheels;



@end

@implementation MusitListViewController

-(void)dealloc{
    
    [_headDic release];
    [_songArray release];
    [_myview release];
    [_tableView release];
   
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.headDic = [NSDictionary dictionary];
    self.songArray = [NSMutableArray array];
    
    

    
    
    //返回按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = button;
    
    //正在播放按钮
    
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-bofangxianshi-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(nowPlay:)];
    
    self.navigationItem.rightBarButtonItem = playButton;
    
    
    //解析数据  头视图
    NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/getsonglist?id=%@&version=5.8.2",self.ID];
    
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.headDic = [responseObject objectForKey:@"data"];
        
        [self headView];
        
    
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    NSString *songStr = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/getsonglistsong?id=%@",self.ID];
    NSString *songStr1 = [songStr stringByAppendingString:@"&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&userfields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CYCRQ%2CFCRQ%2CCC%2CBG%2CDJ%2CRC%2CMC%2CAU%2CSR%2CSG%2CVG%2CISC&version=5.8.2"];
    
    [LCYNewWorking GetDataWithURL:songStr1 dic:nil success:^(id responseObject) {
        
        self.songArray = [responseObject objectForKey:@"data"];
        
        if (self.songArray.count != 0) {
            
            //NSLog(@"%@",self.songArray);

            [self numberOfSong];
            
            [self.tableView reloadData];

        }else{
            
         
        }
        
        
    } failed:^(NSError *error) {
    
        NSLog(@"%@",error);
        
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight) style:UITableViewStylePlain];
    //Kheight - 260 * KH - 64 - 49
    self.tableView.contentInset = UIEdgeInsetsMake(260 * KH, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [_tableView release];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.songArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"song";
    
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[MusicListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    OneList *oneList = [OneList oneListWithDictionary:self.songArray[indexPath.row]];
    
    cell.oneList = oneList;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 70 * KH;
}

#pragma mark 点击时间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    
    playView.musicUrl = [self.songArray[indexPath.row] objectForKey:@"FN"];
    
    playView.user = [self.songArray[indexPath.row]objectForKey:@"user"];
    
    playView.SW = [self.songArray[indexPath.row] objectForKey:@"SW"];
    
    playView.SN = [self.songArray[indexPath.row] objectForKey:@"SN"];
    
    [self.navigationController pushViewController:playView animated:YES];
    
}


#pragma mark 头视图
-(void)headView{
    
    self.myview = [[UIView alloc]initWithFrame:CGRectMake(0, -260 * KH, Kwidth, 260 * KH)];
    
     ///////
    [self.tableView addSubview:self.myview];
    
    //头视图图片
    UIImageView *headPicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, 150 * KH)];
    //[headPicture sd_setImageWithURL:[NSURL URLWithString:[self.headDic objectForKey:@"P"]]];
    [headPicture sd_setImageWithURL:[NSURL URLWithString:[self.headDic objectForKey:@"P"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    
    
    [self.myview addSubview:headPicture];
    
    [headPicture release];
    //黑色背景
    UIView *blackGround = [[UIView alloc]initWithFrame:CGRectMake(0, 110 * KH, Kwidth, 40 * KH)];
    blackGround.backgroundColor = [UIColor blackColor];
    blackGround.alpha = 0.5;
    
    [headPicture addSubview:blackGround];
    
    [blackGround release];
    
    
    //用户头像 用户名
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(50 * KW, 123 * KH, 200 *KW, 20 * KH)];
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont systemFontOfSize:14 * KW];
    userName.text = [[self.headDic objectForKey:@"user"] objectForKey:@"NN"];
    [headPicture addSubview:userName];
    [userName release];
    
    
    UIImageView *userHead = [[UIImageView alloc]initWithFrame:CGRectMake(10 * KW, 117 * KW, 30 * KW, 30 * KH)];
    //[userHead sd_setImageWithURL:[NSURL URLWithString:[[self.headDic objectForKey:@"user"] objectForKey:@"I"]]];
    
    [userHead sd_setImageWithURL:[NSURL URLWithString:[[self.headDic objectForKey:@"user"] objectForKey:@"I"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    
    userHead.layer.cornerRadius = 15 *KW;
    userHead.alpha = 1;
    userHead.layer.masksToBounds = YES;
    [headPicture addSubview:userHead];
    [userHead release];
    
    
    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(10 * KW, 150 * KH , Kwidth - 20 * KW, 60 * KH)];
    detail.numberOfLines = 2;
    detail.font = [UIFont systemFontOfSize:13 * KW];

    
    if ([[NSNull null]isEqual:[self.headDic objectForKey:@"C"]]) {
        
        detail.text = @"无描述";
    }
    else{
        
        detail.text = [self.headDic objectForKey:@"C"];
    }
    
    
    [self.myview addSubview:detail];
    [detail release];
    
    /////////////////////////////////////////////////////////////
    
    UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * KW, 195 * KH, 300 * KW, 20 * KH)];
    listLabel.textColor = [UIColor grayColor];
    listLabel.font = [UIFont systemFontOfSize:12 * KW];
    
    if ([[NSNull null]isEqual:[self.headDic objectForKey:@"L"]]) {
        
        listLabel.text = @"无分类";
    }
    else{
        
        listLabel.text = [self.headDic objectForKey:@"L"];
    }
    
    [self.myview addSubview:listLabel];
    [listLabel release];
    

    [_myview release];
}

-(void)numberOfSong{
    
    UIView *grayview = [[UIView alloc]initWithFrame:CGRectMake(0, 225 *KH, Kwidth, 35 * KH)];
    grayview.backgroundColor = [UIColor lightGrayColor];
    grayview.alpha = 0.4;
    [self.myview addSubview:grayview];
    
    

    UILabel *songNumber = [[UILabel alloc]initWithFrame:CGRectMake(10 * KW, 8 * KH, 200 * KW, 20 * KH)];
    songNumber.font = [UIFont systemFontOfSize:13 * KW];
    if (self.songArray.count != 0) {
        songNumber.text = [NSString stringWithFormat:@"全部歌曲 (共%ld首)",self.songArray.count];
        [grayview addSubview:songNumber];
    }
    
    
    
    [songNumber release];
    [grayview release];
    
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
