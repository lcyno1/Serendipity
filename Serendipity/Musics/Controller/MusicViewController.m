//
//  MusicViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/19.
//  Copyright © 2015年 李重阳. All rights reserved.
//

/*
乐库首页 :推荐页 歌单页 排行榜页  搜索  音乐界面
*/


#import "MusicViewController.h"
#import "EverydayView.h"
#import "AFNetworking.h"
#import "LCYNewWorking.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendList.h"
#import "SearchViewController.h"
#import "RadioCollectionViewCell.h"
#import "RadioList.h"
#import "ProjectList.h"
#import "ProjectTableViewCell.h"
#import "SongList.h"
#import "SongListCollectionViewCell.h"
#import "Charts.h"
#import "ChartsCollectionViewCell.h"
#import "MusicLabelLine.h"
#import "MoreProjectViewController.h"
#import "TwoProViewController.h"
#import "SongListViewController.h"
#import "MusitListViewController.h"
#import "PlayingViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "StyleViewController.h"
#import "OneRadioViewController.h"
#import "MusicDatabase.h"


#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高


@interface MusicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,StyleViewControllerDelegate>

@property(nonatomic,retain)UICollectionView *mainCollectionView;  //最底层,控制三个页面切换
//推荐页的底层scrollView
@property(nonatomic,retain)UIScrollView *scrollView;
//歌单页的scrollView
@property(nonatomic,retain)UIScrollView *songListScrollView;
//排行榜底层view
@property(nonatomic,retain)UIView *chartsView;
//推荐列表的数组
@property(nonatomic,retain)NSArray *recommendListArray;
//储推荐电台的数组
@property(nonatomic,retain)NSArray *radioListArray;
//歌单页面的数组
@property(nonatomic,retain)NSMutableArray *songListArray;
//专题数组
@property(nonatomic,retain)NSArray *projectArray;
//排行榜数组
@property(nonatomic,retain)NSMutableArray *chartsArray;
//轮播图
@property(nonatomic,retain)UIScrollView *LBTscroll;
@property(nonatomic,retain)UIView *LBTview;  //轮播图
//推荐信息字典
@property(nonatomic,retain)NSDictionary *dictionary;

@property(nonatomic,retain)NSMutableArray *LBTarray;
@property(nonatomic,retain)NSArray *urlArray ;
//歌单刷新次数
@property(nonatomic,assign)NSInteger songListNum;
//歌单
@property(nonatomic,retain)UICollectionView *songListViewCollectionView;

@property(nonatomic,assign)BOOL playingMusic;

@end

@implementation MusicViewController

-(void)dealloc{
    
    [_mainCollectionView release];
    [_scrollView release];
    [_songListScrollView release];
    [_chartsView release];
    [_recommendListArray release];
    [_radioListArray release];
    [_songListArray release];
    [_projectArray release];
    [_chartsArray release];
    [_LBTscroll release];
    [_LBTview release];
    [_LBTarray release];
    [_dictionary release];
    [_urlArray release];
    [_songListViewCollectionView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"显示隐藏" object:nil ];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dictionary = [NSDictionary dictionary];
    self.LBTarray = [NSMutableArray array];
    self.urlArray = [NSArray array];
    self.songListArray = [NSMutableArray array];
    
    //接收消息执行
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBar:) name:@"显示隐藏" object:nil];
    
    //隐藏navigationBar 用自定义视图代替
    self.navigationController.navigationBar.hidden = YES;

    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 * KH, Kwidth, 44 * KH)];
    navigationView.userInteractionEnabled = YES;
    [self.view addSubview:navigationView];
    [navigationView release];
    
    //定义UINavigationController的按钮
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(10 * KW, 15 * KW, 20 * KW, 20 * KH);
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
    UIButton *songListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    songListButton.frame = CGRectMake(navigationView.frame.size.width / 2 - 30 * KH , 10 * KH, 60 * KW, 30 * KH);
    songListButton.tag = 101;
    [songListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [songListButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    [songListButton setTitle:@"歌单" forState:UIControlStateNormal];
    [navigationView addSubview:songListButton];
    
    
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendButton.frame = CGRectMake(songListButton.frame.origin.x - 90 * KW, 10 * KH, 60 * KW, 30 * KH);
    recommendButton.tag = 100;
    [recommendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor colorWithRed:66/256.0 green:177/256.0 blue:87/256.0 alpha:1] forState:UIControlStateNormal];
    [recommendButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:20 * KW];
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [navigationView addSubview:recommendButton];
    
    
    UIButton *ListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ListButton.frame = CGRectMake(songListButton.frame.origin.x + 90 * KW, 10 * KH, 70 * KW, 30 * KH);
    ListButton.tag = 102;
    [ListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ListButton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchUpInside];
    [ListButton setTitle:@"排行榜" forState:UIControlStateNormal];
    [navigationView addSubview:ListButton];
   
    //最底层collectionView
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc]init];
    mainLayout.minimumLineSpacing = 0;
    mainLayout.minimumInteritemSpacing = 0;
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, Kwidth, 2000 * KH) collectionViewLayout:mainLayout];
    //Kheight - 64
    
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"main"];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    self.mainCollectionView.pagingEnabled = YES;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.tag = 10;
    [self.view addSubview:self.mainCollectionView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight - 64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    //调用轮播图方法
    [self repeats];
    
    //调用每日推荐方法
    [self everyday];
    
    //调用推荐歌单方法
    [self recommendList];
    
    //调用推荐电台方法
    [self recommendRadio];
    
    //调用专题方法
    [self project];
    
    //调用歌单页面方法
    [self songListView];
    
    //调用排行榜页面
    [self charts];
    
    self.scrollView.contentSize = CGSizeMake(Kwidth, (785 + 270) * KH);
    
    [mainLayout release]; ////
    [_scrollView release];
    [_mainCollectionView release];

    
}

#pragma mark 执行通知
-(void)showBar:(NSNotification *)notification{
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark 推荐页轮播图
-(void)repeats{
    
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, 130 * KH)];
    cycleScrollView.delegate = self;
    [self.scrollView addSubview:cycleScrollView];
   
    NSString *url = @"http://goapi.5sing.kugou.com/getAdvert?t=101&tag=294&version=5.8.2";
    
    [LCYNewWorking GetDataWithURL:url dic:nil success:^(id responseObject) {
        self.urlArray = [NSArray array];

        self.urlArray = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in self.urlArray) {
            
            NSString *str = [dic objectForKey:@"ImgUrl"];
            [self.LBTarray addObject:str];
        }
        cycleScrollView.imageURLStringsGroup = self.LBTarray;
        
    } failed:^(NSError *error) {
        
    }];
  
    [cycleScrollView release];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([[self.urlArray[index] objectForKey:@"LinkUrl"]hasPrefix:@"http"]) {
        
        TwoProViewController *oneView = [[TwoProViewController alloc]init];
        oneView.urlStr = [self.urlArray[index] objectForKey:@"LinkUrl"];
        oneView.nameTitle = [self.urlArray[index] objectForKey:@"Title"];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:oneView animated:YES];
        
    }else{
   
    MusitListViewController *view = [[MusitListViewController alloc]init];
    view.ID = [self.urlArray[index] objectForKey:@"LinkUrl"];
    [self.navigationController pushViewController:view animated:YES];
    [view release];
    }
}
#pragma mark 每日推荐
-(void)everyday{
    
    MusicLabelLine *label = [[MusicLabelLine alloc]initWithFrame:CGRectMake(0 * KW, (self.LBTview.frame.origin.y + 140) * KH, Kwidth, 20 * KH)];
    label.label.text = @"每日推荐";
    [self.scrollView addSubview:label];
    [label release];
    
    
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(10 * KW, (self.LBTview.frame.origin.y + 162) * KH, Kwidth - 18 * KW, 101 * KH)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iconfont-juchibeijing"]];
    [imageView setBackgroundColor:color];
    [self.scrollView addSubview:imageView];
    [imageView release];
    
    
    EverydayView *everydayView = [[EverydayView alloc]initWithFrame:CGRectMake(3 * KW, 3 * KH, Kwidth - 26 * KW, (100 - 6) * KH)];
    everydayView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:everydayView];
    [everydayView release];
    
    
    //进行网络请求
    NSString *str = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/getRecommendDailyList?&version=5.8.2"];
    
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.dictionary = [[responseObject objectForKey:@"data"]lastObject];
        
        everydayView.titleLabel.text = [self.dictionary objectForKey:@"RecommendName"];
        
        everydayView.recommendWords.text = [self.dictionary objectForKey:@"RecommendWords"];
        
        //[everydayView.Picture sd_setImageWithURL:[NSURL URLWithString:[self.dictionary objectForKey:@"Picture"]]];
        [everydayView.Picture sd_setImageWithURL:[NSURL URLWithString:[self.dictionary objectForKey:@"Picture"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    //给每日视图加轻拍手势
    UITapGestureRecognizer *everdayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(everydayTap:)];
    
    [everydayView addGestureRecognizer:everdayTap];
    [everdayTap release];
    
}

#pragma mark 每日推荐手势
-(void)everydayTap:(UITapGestureRecognizer *)tap{
    
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    
    playView.musicUrl = [[self.dictionary objectForKey:@"Content"] objectForKey:@"Uri"];
    
    playView.user = [self.dictionary objectForKey:@"Content"];
    
    playView.SN = [self.dictionary objectForKey:@"RecommendName"];
    
    playView.SW = @"暂无歌词";
    
    [self.navigationController pushViewController:playView animated:YES];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark 推荐歌单
-(void)recommendList{

    //推荐歌单标题
    MusicLabelLine *label = [[MusicLabelLine alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 270) * KH, Kwidth, 20 * KH)];
    label.label.text = @"推荐歌单";
    [self.scrollView addSubview:label];
    [label release];
    
    //推荐歌单collectionView
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 293) * KH, Kwidth, 140 * KH) collectionViewLayout:layout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.tag = 1;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"recommendList"];
    
    [self.scrollView addSubview:collectionView];
    
    
    //解析数据
    NSString *str = @"http://goapi.5sing.kugou.com/getRecommendSongList?&version=5.8.2";
    
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.recommendListArray = [responseObject objectForKey:@"data"];
        
        [collectionView reloadData];
        
        
    } failed:^(NSError *error) {
        
    }];
    
    [layout release];
    [collectionView release];
    
}


#pragma mark 推荐电台
-(void)recommendRadio{
    
    //推荐电台标题
    MusicLabelLine *label = [[MusicLabelLine alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 445) * KH, Kwidth, 20 * KH)];
    label.label.text = @"推荐电台";

    [self.scrollView addSubview:label];
    [label release];
    
    UICollectionViewFlowLayout *radioLayout = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 464) * KH, Kwidth, 340 * KH) collectionViewLayout:radioLayout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[RadioCollectionViewCell class] forCellWithReuseIdentifier:@"radioList"];
    
    
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.tag = 2;
    
    [self.scrollView addSubview:collectionView];

    //解析数据
    NSString *str = @"http://api2.pianke.me/ting/radio";
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"auth=&client=1&deviceid=E67F22E8-A87F-45D4-A3F3-5182C1585430&version=3.0.6",@"auth", nil];
    
    [LCYNewWorking PostDataWithURL:str dic:dic success:^(id responseObject) {
        
        self.radioListArray = [[responseObject objectForKey:@"data"] objectForKey:@"alllist"];
        
        [collectionView reloadData];
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [radioLayout release];
    [collectionView release];
    
}

#pragma mark 专题
-(void)project{
    
    //专题标题
    MusicLabelLine *label = [[MusicLabelLine alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 760) * KH, Kwidth - 75 * KW, 20 * KH)];
    label.label.text = @"专题";
    [self.scrollView addSubview:label];
    [label release];
    
    //更多按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(310 *KW, (self.LBTview.frame.origin.y + 757) * KH, 30 *KW , 30 *KH);
    [button setTitle:@"更多" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14 * KW];
    [button addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:button];
    
    //更多图标
    UIImageView *moreView = [[UIImageView alloc]initWithFrame:CGRectMake(340 *KW, (self.LBTview.frame.origin.y + 764) * KH, 16 * KW , 16 * KH)];
    moreView.image = [UIImage imageNamed:@"iconfont-gengduo"];
    [self.scrollView addSubview:moreView];
    [moreView release];
    
    
    //创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (self.LBTview.frame.origin.y + 780) * KH, Kwidth, 220 * KH) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    
    //解析数据
    
    NSString *str = @"http://goapi.5sing.kugou.com/getTheme?t=101&o1=1&o2=2&tag=66&version=5.8.2";
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.projectArray = [responseObject objectForKey:@"data"];
        
        [tableView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
  
    [self.scrollView addSubview:tableView];

    [tableView release];
}


-(void)clickMore:(UIButton *)sender{
    
    MoreProjectViewController *more = [[MoreProjectViewController alloc]init];
   
    [self.navigationController pushViewController:more animated:YES];
     more.navigationController.navigationBar.hidden = NO;
    [more release];
}



#pragma mark 歌单页面
-(void)songListView{
    
    self.songListScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0  * KW, Kwidth, Kheight - 64 - 24 * KH)];
    self.songListScrollView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"推荐" forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(20 * KW, 10 * KH, 50 * KW, 30 * KH);
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    moreButton.layer.borderWidth = 0.3;
    [moreButton addTarget:self action:@selector(moreStyle:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 5;
    moreButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.songListScrollView addSubview:moreButton];
    
    UICollectionViewFlowLayout *songListViewLayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.songListViewCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, Kwidth, Kheight - 64 - 74 * KH) collectionViewLayout:songListViewLayout];
    
    [self.songListViewCollectionView addHeaderWithCallback:^{
       
        [self.songListViewCollectionView reloadData];
        
        [self.songListViewCollectionView headerEndRefreshing];
    }];

    
    self.songListViewCollectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.songListViewCollectionView.tag = 3;
    self.songListViewCollectionView.dataSource = self;
    self.songListViewCollectionView.delegate = self;
    
    [self.songListViewCollectionView registerClass:[SongListCollectionViewCell class] forCellWithReuseIdentifier:@"songlistView"];
    
    //解析数据
    NSString *str = @"http://goapi.5sing.kugou.com/getSongListSquareRecommended?index=1&version=5.8.2";
    
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        [self.songListArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
        
        [self.songListViewCollectionView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    self.songListNum = 2;
    
    [self.songListViewCollectionView addFooterWithCallback:^{
       
        if ([moreButton.titleLabel.text isEqualToString:@"推荐"]) {
            
        NSString *str = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/getSongListSquareRecommended?index=%ld&version=5.8.2",self.songListNum ];
        [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
            
            NSArray *array = [NSArray array];

            array = [responseObject objectForKey:@"data"];
            
            [self.songListArray addObjectsFromArray:array ];
            
            [self.songListViewCollectionView reloadData];
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
       
        }else{
            
            
            NSString *result = [moreButton.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:moreButton.titleLabel.text]];
            
            NSString *str = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/search/songSquare?label=%@&sortType=1&pn=1&ps=%ld&version=5.8.2",result,self.songListNum * 10];
            
            
            [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
                
                self.songListArray = [[responseObject objectForKey:@"data"] objectForKey:@"songMenu"];
                
                [self.songListViewCollectionView reloadData];
                
            } failed:^(NSError *error) {
                
                NSLog(@"%@",error);
                
            }];
  
             self.songListNum++;
            
        }
        
        [self.songListViewCollectionView footerEndRefreshing];
    }];
    
 
    [self.songListScrollView addSubview:self.songListViewCollectionView];
    [songListViewLayout release];
    [_songListViewCollectionView release];
    [_songListScrollView release];
    
}

-(void)moreStyle:(UIButton *)sender{
    
    StyleViewController *styleView = [[StyleViewController alloc]init];
    [self.navigationController pushViewController:styleView animated:YES];
    styleView.delegate = self;
    
    
    [styleView release];
    
}

-(void)changeStyle:(NSString *)style{
    
    [((UIButton *)[self.view viewWithTag:5])setTitle:style forState:UIControlStateNormal];
    
    //解析数据
    if ([style isEqualToString:@"推荐"]) {
        
        NSString *str = @"http://goapi.5sing.kugou.com/getSongListSquareRecommended?index=1&version=5.8.2";
        
        [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
                        
            NSMutableArray *array = [NSMutableArray array];
            
            [array addObjectsFromArray:[responseObject objectForKey:@"data"]];
            
            self.songListArray = array;
            
            //[self.songListArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            
            
            [self.songListViewCollectionView reloadData];
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
        
    }
    else{
        
    NSString *result = [style stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:style]];
    
    NSString *str = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/search/songSquare?label=%@&sortType=1&pn=1&ps=10&version=5.8.2",result];
    
    
        [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {

            self.songListArray = [[responseObject objectForKey:@"data"] objectForKey:@"songMenu"];
            
            [self.songListViewCollectionView reloadData];
    
        } failed:^(NSError *error) {
    
            NSLog(@"%@",error);
            
        }];
    }
}

#pragma mark 排行榜页面
-(void)charts{
    self.chartsView = [[UIView alloc]initWithFrame:self.view.frame];
    self.chartsView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView *chartsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, Kwidth, 600) collectionViewLayout:layout];
    [chartsCollectionView registerClass:[ChartsCollectionViewCell class] forCellWithReuseIdentifier:@"charts"];
    chartsCollectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    chartsCollectionView.dataSource = self;
    chartsCollectionView.delegate = self;
    chartsCollectionView.tag = 4;
    
    //解析数据
    NSString *str = @"http://mobileapi.5sing.kugou.com/rank/list?&version=5.8.2";
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.chartsArray = [responseObject objectForKey:@"data"];
        
        [chartsCollectionView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    

    [self.chartsView addSubview:chartsCollectionView];
    [layout release];
    [chartsCollectionView release];
    [_chartsView release];
}


#pragma mark tableView单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

#pragma mark 自定义tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"project";
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[ProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];////
    }
    
    ProjectList *project = [ProjectList projectListWithDictionary:self.projectArray[indexPath.row]];
    cell.projectList = project;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110 * KH;
}

#pragma mark tableView点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TwoProViewController *oneView = [[TwoProViewController alloc]init];
    
    oneView.nameTitle = [self.projectArray[indexPath.row] objectForKey:@"Title"];
    
    oneView.urlStr = [self.projectArray[indexPath.row] objectForKey:@"Url"];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:oneView animated:YES];
    
    [oneView release];

}

#pragma mark 返回单元格数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //推荐歌单单元格
    if (collectionView.tag == 1) {
    
    return 3;
        
    }else if(collectionView.tag == 2){  //推荐电台单元格
        
        return 3;
    }else if (collectionView.tag == 3){ // 歌单页面单元格
        
        return self.songListArray.count ;
    }else if (collectionView.tag == 4){
        
        return self.chartsArray.count ;
    }
    else{
        return 3;
    }
}

#pragma mark 自定义单元格
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

//    推荐歌单单元格
    if (collectionView.tag == 1) {
    
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendList" forIndexPath:indexPath];
    
    RecommendList *recommendList = [RecommendList recommendListWithDictionary:self.recommendListArray[indexPath.item]];
    
    cell.recommendList = recommendList;
    
    return cell;
    }
    else if(collectionView.tag == 2){     //推荐电台单元格
        
        RadioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"radioList" forIndexPath:indexPath];
        
        RadioList *radioList = [RadioList radioListWithDcitionary:self.radioListArray[indexPath.item]];
        
        cell.radioList = radioList;
        
        return cell;
        
    }else if (collectionView.tag == 3){
        
        SongListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"songlistView" forIndexPath:indexPath];
        
        SongList *songList = [SongList songListWithDictionary:self.songListArray[indexPath.item]];
        
        cell.songList = songList;
        
        return cell;
        
    }else if (collectionView.tag == 4){
        
        
        ChartsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"charts" forIndexPath:indexPath];
        
        Charts *charts = [Charts chartsWithDictionary:self.chartsArray[indexPath.item]];
        
        cell.charts = charts;
        
        
        return cell;
    }
    else{
      
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"main" forIndexPath:indexPath];
        
        
        if (indexPath.item == 0) {

            [cell.contentView addSubview:self.scrollView];
        }
        else if (indexPath.item == 2){
            
            [cell.contentView addSubview:self.chartsView];
        }
        else{

        [cell.contentView addSubview:self.songListScrollView];

        }
        
        return cell;
    }
    
}

#pragma mark 返回单元格item间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //推荐歌单单元格
    if (collectionView.tag == 1) {
    
    return UIEdgeInsetsMake(0, 15 * KW, 0, 15 * KW);
    
    }
    else if(collectionView.tag == 2){ //推荐电台单元格
        
        
        return UIEdgeInsetsMake(0, 5 * KW, 3 * KH, 5 * KW);
        
    }else if (collectionView.tag == 3){
        
        return UIEdgeInsetsMake(5 * KH, 5 * KW, 5 * KH, 5 * KW);
        
    }
    else if (collectionView.tag == 4){
        
        return UIEdgeInsetsMake(5 * KH, 15 * KW, 15 * KH, 5 * KW);
        
    }
    else{
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}

#pragma mark 定义最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

#pragma mark 定义单元格尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //推荐歌单单元格
    if (collectionView.tag == 1) {
    
        CGSize size = CGSizeMake(95 * KW, 130 * KH);
    
        return size;
    }
    else if(collectionView.tag == 2){   //推荐歌单单元格
        
        CGSize size = CGSizeMake(Kwidth - 10 * KW, 95 * KH);
        
        return size;
    }else if (collectionView.tag == 3){
        
        
        CGSize size = CGSizeMake(Kwidth/ 2 - 20 * KW, 180 * KH);
        
        return size;
        
    }
    else if (collectionView.tag == 4){
        
        CGSize size = CGSizeMake(Kwidth - 10 * KW, 120 * KH);
        
        return size;
        
    }
    else{
        
        return CGSizeMake(Kwidth ,2000 * KW);
        
    }
}


#pragma mark 单元格点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 1) {
        
        MusitListViewController *musitView = [[MusitListViewController alloc]init];
        
        musitView.ID = [self.recommendListArray[indexPath.item] objectForKey:@"SongListId"];
        
        [self.navigationController pushViewController:musitView animated:YES];
        
        self.tabBarController.tabBar.hidden = YES;
        
        self.navigationController.navigationBar.hidden = NO;
        
        [musitView release];
        
        
    }
    else if(collectionView.tag == 2){
        
        OneRadioViewController *oneView = [[OneRadioViewController alloc]init];
        oneView.key = [self.radioListArray[indexPath.item] objectForKey:@"radioid"];
        [self.navigationController pushViewController:oneView animated:YES];
        [oneView release];
    }
    if (collectionView.tag == 3) {
        
        MusitListViewController *view = [[MusitListViewController alloc]init];
        
        
        
        if ([self.songListArray[indexPath.item] objectForKey:@"ID"] == nil) {
            view.ID = [self.songListArray[indexPath.item] objectForKey:@"listId"];
            NSLog(@"%@",view.ID);
        }else{
            
            view.ID = [self.songListArray[indexPath.item] objectForKey:@"ID"];

        }
        
        [self.navigationController pushViewController:view animated:YES];
        
        self.tabBarController.tabBar.hidden = YES;
        
        self.navigationController.navigationBar.hidden = NO;
        
        [view release];
        
        
    }
    if (collectionView.tag == 4) {
        
        NSArray *type = @[@"yc",@"fc",@"list23",@"best"];
        
        SongListViewController *listView = [[SongListViewController alloc]init];
        
        listView.type = type[indexPath.item];
        
        [self.navigationController pushViewController:listView animated:YES];
        
        self.navigationController.navigationBar.hidden = NO;
        
        [listView release];
    }
    
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

#pragma mark 正在播放按钮
-(void)playing:(UIButton *)button{
    
    
    MusicDatabase *dataBase = [MusicDatabase musicDatabase];
    
    NSArray *array = [NSArray array];
    
    array = [dataBase historyAllMusic];
    
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    
    
    //self.playingMusic = NO;
//    playView.playingMusic = ^(BOOL playingMusic){
//      
//        NSLog(@"%d",playingMusic);
//        
//        self.playingMusic = playingMusic;
//    };
//    
//    NSLog(@"%d",self.playingMusic);
    
    if (array.count != 0 ) {
       
        
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
        
       [( (UIButton *)[self.view viewWithTag:i] )setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]  ;
        ((UIButton *)[self.view viewWithTag:i]).titleLabel.font = [UIFont systemFontOfSize:17 * KW];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
