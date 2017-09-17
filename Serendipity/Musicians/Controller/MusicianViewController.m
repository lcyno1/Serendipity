//
//  MusicianViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/19.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MusicianViewController.h"
#import "SearchViewController.h"
#import "MusicianList.h"
#import "MusicianCollectionViewCell.h"
#import "MusicianTableViewCell.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "LCYNewWorking.h"
#import "FamousCollectionViewCell.h"
#import "PlayingViewController.h"
#import "MusicDatabase.h"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface MusicianViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//最底层视图
@property(nonatomic,retain)UICollectionView *mainCollectionView;
//新入驻数组
@property(nonatomic,retain)NSMutableArray *newpArray;
//推荐人数组
@property(nonatomic,retain)NSMutableArray *recommendpArray;
//周榜数组
@property(nonatomic,retain)NSMutableArray *weekArray;
//月榜数组
@property(nonatomic,retain)NSMutableArray *monthArray;
//总榜数组
@property(nonatomic,retain)NSMutableArray *allArray;
//点击状态数组
@property(nonatomic,retain)NSMutableArray *tempArray;
//头视图
@property(nonatomic,retain) UITableViewHeaderFooterView *headview ;
//下拉菜单
@property(nonatomic,retain)UIImageView *listView;
//周,月,总
@property(nonatomic,retain)UILabel *nameLabel;
//下拉状态
@property(nonatomic,assign)BOOL clicklistButton;

@property(nonatomic,assign)NSInteger temp;

@property(nonatomic,assign)BOOL clickMonth;

@property(nonatomic,assign)BOOL clickWeek;

@property(nonatomic,assign)BOOL clickAll;
@end

@implementation MusicianViewController

-(void)dealloc{
    
    [_mainCollectionView release];
    [_newpArray release];
    [_recommendpArray release];
    [_weekArray release];
    [_monthArray release];
    [_allArray release];
    [_tempArray release];
    [_headview release];
    [_listView release];
    [_nameLabel release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.temp = 0;
    
    self.weekArray = [NSMutableArray array];
    self.monthArray = [NSMutableArray array];
    self.allArray = [NSMutableArray array];
    self.tempArray = [NSMutableArray array];
    self.newpArray = [NSMutableArray array];
    self.recommendpArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //隐藏navigationBar 用自定义视图代替
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 * KH, Kwidth, 44 * KH)];
    navigationView.userInteractionEnabled = YES;
    [self.view addSubview:navigationView];
    [navigationView release];
    
    
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(10, 15, 20 * KW, 20 * KH);
    [searchButton addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"iconfont-sousuo-2"] forState:UIControlStateNormal];
    [navigationView addSubview:searchButton];
    
    //正在播放按钮
    UIButton *playingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playingButton.frame = CGRectMake(340 * KW, 12 * KW, 25 * KW, 25 * KH);
    [playingButton setImage:[UIImage imageNamed:@"iconfont-bofangxianshi-2"] forState:UIControlStateNormal];
    [playingButton addTarget:self action:@selector(playing:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:playingButton];

    
    //推荐 歌单 排行榜 按钮
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame = CGRectMake(navigationView.frame.size.width / 2 - 30 * KH , 10 * KH, 70 * KW, 30 * KH);
    newButton.tag = 101;
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:@"新入驻" forState:UIControlStateNormal];
    [navigationView addSubview:newButton];
    
    
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendButton.frame = CGRectMake(newButton.frame.origin.x - 90 * KW, 10 * KH, 70 * KW, 30 * KH);
    recommendButton.tag = 100;
    [recommendButton setTitleColor:[UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1] forState:UIControlStateNormal];
    [recommendButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:20 * KW];
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [navigationView addSubview:recommendButton];
    
    
    UIButton *famousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    famousButton.frame = CGRectMake(newButton.frame.origin.x + 90 * KW, 10 * KH, 70 * KW, 30 * KH);
    famousButton.tag = 102;
    [famousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [famousButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    [famousButton setTitle:@"名人堂" forState:UIControlStateNormal];
    [navigationView addSubview:famousButton];
    
    //最底层collectionView
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc]init];
    mainLayout.minimumLineSpacing = 0;
    mainLayout.minimumInteritemSpacing = 0;
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, Kwidth, Kheight - 64 - 49 ) collectionViewLayout:mainLayout];
    
    [self.mainCollectionView registerClass:[MusicianCollectionViewCell class] forCellWithReuseIdentifier:@"musician"];
    
    [self.mainCollectionView registerClass:[FamousCollectionViewCell class] forCellWithReuseIdentifier:@"famous"];
    
    self.mainCollectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.mainCollectionView.pagingEnabled = YES;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.tag = 10;

    self.headview = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"head"];
    self.headview.frame = CGRectMake(Kheight, 0, Kwidth , 40 * KH);
    self.headview.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    //选择榜单按钮
    UIButton *chooseList = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseList setTitle:@"选择榜单" forState:UIControlStateNormal];
    [chooseList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    chooseList.frame = CGRectMake(280 * KW, 10 * KH, 80 * KW, 28 * KH);
    //[chooseList setBackgroundImage:[UIImage imageNamed:@"iconfont-biankuang"] forState:UIControlStateNormal];
    chooseList.layer.borderColor = [UIColor grayColor].CGColor;
    chooseList.layer.borderWidth = 0.5;
    chooseList.layer.cornerRadius = 3;
    chooseList.layer.masksToBounds = YES;
    chooseList.titleLabel.font = [UIFont systemFontOfSize:13 * KW];
    [chooseList addTarget:self action:@selector(chooseList:) forControlEvents:UIControlEventTouchUpInside];
    
    //头视图
    
    [self.headview addSubview:chooseList];
    self.listView = [[UIImageView alloc]initWithFrame:CGRectMake(280 * KW + 2*Kwidth, 35 * KH, 100 * KW, 140 * KH)];
    self.listView.hidden = YES;
    self.listView.userInteractionEnabled = YES;
    [self.mainCollectionView addSubview:self.listView];
    
    [_headview release];
    
    //周榜 月榜 总榜
    NSArray *nameArray = @[@"周榜",@"月榜",@"总榜"];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i * 30 * KH +10 * KH , 80 * KW, 28 * KH);
        button.tag = 100 + i;
        [button addTarget:self action:@selector(famousList:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 3 *KW;
        button.layer.masksToBounds = YES;
        [self.listView addSubview:button];
        
    }
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60* KW, 10 * KH, 100 * KW, 25 * KH)];
    self.nameLabel.text = @"周榜";
    self.nameLabel.font = [UIFont systemFontOfSize:20 * KW];
    self.nameLabel.textColor = [UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1];
    [self.headview addSubview:self.nameLabel];
    [_nameLabel release];
    
    UIImageView *crown = [[UIImageView alloc]initWithFrame:CGRectMake(28 * KW, 10 * KH, 25 * KW, 25 * KH)];
    crown.image = [UIImage imageNamed:@"iconfont-huangguantubiao"];
    [self.headview addSubview:crown];
    [crown release];
    
    
    //解析数据
    NSString *newStr = @"http://mobileapi.5sing.kugou.com/musician/latestList?songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&pageindex=1&pagesize=8&userid=53233787&version=5.8.2";
    NSString *recommendStr = @"http://mobileapi.5sing.kugou.com/user/listmusician?songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&pageindex=1&pagesize=10&userid=53233787&version=5.8.2";
    
    NSString *weekList = @"http://goapi.5sing.kugou.com/getRank?t=1&o1=1&o2=10&version=5.8.2";
    
    NSString *monthList = @"http://goapi.5sing.kugou.com/getRank?t=2&o1=1&o2=10&version=5.8.2";
    
    NSString *allList = @"http://mobileapi.5sing.kugou.com/musician/hotList?songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&pageindex=1&pagesize=10&userid=53233787&version=5.8.2";
    
    //新入驻数据请求
    [LCYNewWorking GetDataWithURL:newStr dic:nil success:^(id responseObject) {
        
        self.newpArray = [responseObject objectForKey:@"data"];
        [self.mainCollectionView reloadData];
        

    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    //推荐数据请求
    [LCYNewWorking GetDataWithURL:recommendStr dic:nil success:^(id responseObject) {
        
        self.recommendpArray = [responseObject objectForKey:@"data"];
        
        [self.mainCollectionView reloadData];
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    //周榜数据请求
    [LCYNewWorking GetDataWithURL:weekList dic:nil success:^(id responseObject) {
        
        self.weekArray = [responseObject objectForKey:@"data"];
        self.tempArray = self.weekArray;

        [self.mainCollectionView reloadData];
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    //月榜数据请求
    [LCYNewWorking GetDataWithURL:monthList dic:nil success:^(id responseObject) {
        
        self.monthArray = [responseObject objectForKey:@"data"];
        [self.mainCollectionView reloadData];
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    //总榜数据请求
    [LCYNewWorking GetDataWithURL:allList dic:nil success:^(id responseObject) {
        
       self.allArray = [responseObject objectForKey:@"data"];
        [self.mainCollectionView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
    [self.view addSubview:self.mainCollectionView];
    [_mainCollectionView release];
    
}
//榜单按钮
-(void)chooseList:(UIButton *)sender{
    if (self.clicklistButton == NO) {
        [self.view bringSubviewToFront:self.listView];
        self.listView.hidden = NO;
        self.clicklistButton = YES;
        
    }else{
        self.listView.hidden = YES;
        self.clicklistButton = NO;
        
    }
   

}
//三个榜单
-(void)famousList:(UIButton *)sender{
    
    self.listView.hidden = YES;
    self.clicklistButton = NO;
    if (sender.tag == 100) {
        self.nameLabel.text = @"周榜";
        self.clickMonth = NO;
        self.clickWeek = YES;
        self.clickAll = NO;
    }
    if (sender.tag == 101) {
        self.nameLabel.text = @"月榜";
        self.clickMonth = YES;
        self.clickWeek = NO;
        self.clickAll = NO;
    }
    if (sender.tag == 102) {
        self.nameLabel.text = @"总榜";
        self.clickMonth = NO;
        self.clickWeek = NO;
        self.clickAll = YES;
    }
    
    [self.mainCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MusicianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musician" forIndexPath:indexPath];

    FamousCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"famous" forIndexPath:indexPath];
    cell.root = self;
    cell1.root = self;
    if (indexPath.item == 0) {
        //设置第一次正常 向会滑时候 头视图隐藏,第一个tableView高度上提
        if (self.temp  > 3) {
            cell1.tableView.frame = CGRectMake(0, 24 * KH, Kwidth, Kheight + 64 * KH);

        }
        self.temp++;
        cell.tableViewArray = self.recommendpArray;
        cell.tableView.tableHeaderView.hidden = YES;
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [cell.tableView reloadData];
        return cell;
    }
    else if(indexPath.item == 1){
      
        cell.tableViewArray = self.newpArray;
        [cell.tableView reloadData];
         cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        return cell;
     
    }else{
        //判断当前点击的榜单
        if (self.clickMonth == YES) {
            self.tempArray = self.monthArray;
        }
        if (self.clickWeek == YES) {
            self.tempArray = self.weekArray;
        }
        if (self.clickAll == YES) {
            self.tempArray = self.allArray;
        }
        
            cell1.tableViewArray = self.tempArray;
        
            [cell1.tableView reloadData];
       
            [cell1.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"head"];
            cell1.tableView.tableHeaderView = self.headview;
        self.headview.backgroundColor = [UIColor orangeColor];
            cell1.tableView.tableHeaderView.hidden = NO;
            cell1.tableView.frame = CGRectMake(0, 64 * KH, Kwidth, Kheight - 110 *KH);
            cell1.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        return cell1;
            
    }
  
}


#pragma mark 定义单元格尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     return CGSizeMake(Kwidth ,Kheight);
    
}

#pragma mark mainCollectionView的滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 10) {
        
        int now = scrollView.contentOffset.x / Kwidth;
        
        [self changeButtonColor];
        
        [((UIButton *)[self.view viewWithTag:100 + now])setTitleColor:[UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)[self.view viewWithTag:100 + now]).titleLabel.font = [UIFont systemFontOfSize:20 * KW];
    }
    
}

#pragma mark 搜索按钮
-(void)clickSearch:(UIBarButtonItem *)sender{
    
    
    SearchViewController *searchView = [[SearchViewController alloc]init];
    
    [self.navigationController pushViewController:searchView animated:YES];
    
    searchView.navigationController.navigationBar.hidden = NO;
    
    [searchView release];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark 正在播放按钮
-(void)playing:(UIButton *)button{
    
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

#pragma mark 头排榜按钮方法
-(void)ListButton:(UIButton *)sender{
    [self changeButtonColor];
    NSInteger a = sender.tag - 100;
    self.mainCollectionView.contentOffset = CGPointMake(a * Kwidth, 0);
    [sender setTitleColor:[UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:20 * KW];
    
}


-(void)changeButtonColor{
    
    for (int i = 100; i < 103; i++) {
        
        [( (UIButton *)[self.view viewWithTag:i] )setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        ((UIButton *)[self.view viewWithTag:i]).titleLabel.font = [UIFont systemFontOfSize:17 * KW];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
