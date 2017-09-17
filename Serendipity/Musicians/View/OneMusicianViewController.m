//
//  OneMusicianViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/25.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneMusicianViewController.h"
#import "MusicianViewController.h"
#import "LCYNewWorking.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "OneMusicianCell.h"
#import "MessengCollectionViewCell.h"
#import "PlayingViewController.h"
#import "MusicDatabase.h"


#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface OneMusicianViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//音乐人信息数组
@property(nonatomic,retain)NSDictionary *musician;

@property(nonatomic,retain)UIPageControl * pageControl;

//头视图
@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)UICollectionView *collectionView;
//作品数组
@property(nonatomic,retain)NSMutableArray *workArray;
//留言数组
@property(nonatomic,retain)NSMutableArray *messengArrray;
//动画背景
@property(nonatomic,retain)UIView *animation;


@end

@implementation OneMusicianViewController

-(void)dealloc{


    [_musician release];
    [_ID release];
    [_pageControl release];
    [_collectionView release];
    [_workArray release];
    [_messengArrray release];
    [super dealloc];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.tabBarController.tabBar.hidden = YES;
    
    self.musician = [NSDictionary dictionary];
    self.workArray = [NSMutableArray array];
    self.messengArrray = [NSMutableArray array];
    
    //返回按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = button;
    
    //正在播放按钮
    
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-bofangxianshi-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(nowPlay:)];
    
    self.navigationItem.rightBarButtonItem = playButton;

    
    //下面大的collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 200 * KW, Kwidth, Kheight - 200 * KH) collectionViewLayout:layout];
   //Kheight - 150 * KH
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.tag = 100;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[OneMusicianCell class] forCellWithReuseIdentifier:@"worklist"];
    [self.collectionView registerClass:[MessengCollectionViewCell class] forCellWithReuseIdentifier:@"messeng"];
    //self.collectionView.contentInset = UIEdgeInsetsMake(160 * KH, 0, 0, 0);
    
    
    [self.view addSubview:self.collectionView];
    
    
    
    //解析数据
    NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/user/get?userid=%@",self.ID];
    
    NSString *str1 = [str stringByAppendingString:@"&fields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CYCRQ%2CFCRQ%2CCC%2CBG%2CDJ%2CRC%2CMC%2CAU%2CSR%2CSG%2CVG%2CISC%2COP&version=5.8.2"];
    
    
    [LCYNewWorking GetDataWithURL:str1 dic:nil success:^(id responseObject) {
        
        self.musician = [responseObject objectForKey:@"data"];
        
        [self taketitle];
        
        [self headView];
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
        
    

    //作品列表
    NSString *workStr = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/user?userid=%@",self.ID];
    NSString *workStr1 = [workStr stringByAppendingString:@"&songtype=yc&pageindex=1&pagesize=20&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&userfields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CYCRQ%2CFCRQ%2CCC%2CBG%2CDJ%2CRC%2CMC%2CAU%2CSR%2CSG%2CVG%2CISC&version=5.8.2"];
    
 
    
    [LCYNewWorking GetDataWithURL:workStr1 dic:nil success:^(id responseObject) {
        
        self.workArray = [responseObject objectForKey:@"data"];
        
        [self.collectionView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    //留言板
    NSString *messengStr = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/comments/list?rootId=%@",self.ID];
    
    NSString *messengStr1 = [messengStr stringByAppendingString:@"&rootKind=guestBook&maxId=0&fields=ID%2CNN%2CI%2CB%2CP%2CC%2CSX%2CE%2CM%2CVT%2CCT%2CTYC%2CTFC%2CTBZ%2CTFD%2CTFS%2CSC%2CDJ&version=5.8.2"];
    
    [LCYNewWorking GetDataWithURL:messengStr1 dic:nil success:^(id responseObject) {
        

        self.messengArrray = [responseObject objectForKey:@"data"];
        [self.collectionView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
    
    //两个按钮
    NSArray *buttonArray = @[@"作品",@"留言板"];
    
    for (int i = 0; i < 2; i++) {
        
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nameButton.frame = CGRectMake(i * Kwidth / 2, 217 * KH, Kwidth / 2, 40 *KH);
        [nameButton setTitle:buttonArray[i] forState:UIControlStateNormal];
        [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nameButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        nameButton.tag = i + 10;
        
        [self.view addSubview:nameButton];
    }
    
    //动画图片
    self.animation = [[UIView alloc]initWithFrame:CGRectMake(0, 217 * KH, Kwidth / 2, 40 * KH)];
    self.animation.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:0.3];
    self.animation.layer.cornerRadius = 7 * KW;
    self.animation.layer.masksToBounds = YES;
    [self.view addSubview:self.animation];
    [_animation release];
    
    [layout release];
    [_collectionView release];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OneMusicianCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"worklist" forIndexPath:indexPath];
    
    MessengCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"messeng" forIndexPath:indexPath];
    
    
    if (indexPath.item == 0) {
        cell.tableViewArray = self.workArray;
        //cell.tableView.scrollEnabled = NO;
        cell.navigationController = self.navigationController;
        [cell.tableView reloadData];
        
        return cell;
    }else{

        cell1.tableViewArray = self.messengArrray;
        //cell1.navigationControkker = self.navigationController;
        [cell1.tableView reloadData];
        
        return cell1;
    }
    

    
    
}

-(void)clickButton:(UIButton *)sender{
    
    //动画效果
    [UIView animateWithDuration:0.5 animations:^{
        //(i * Kwidth / 2, 217 * KH, Kwidth / 2, 40 *KH);
        
        self.animation.frame = CGRectMake((sender.tag - 10) * Kwidth / 2, 217 * KH, Kwidth / 2, 40 * KH);
        
        
        
    }];
    
    //collectionView偏移
    self.collectionView.contentOffset = CGPointMake((sender.tag - 10) * Kwidth, -65 * KH);
    
    
    
}

#pragma mark 定义单元格尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(Kwidth ,Kheight - 200 * KH - 64 - 49  );
    //Kheight - 150 * KH - 64 - 49
}


#pragma mark 定义最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}




#pragma mark 头视图
-(void)headView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Kwidth, 150 * KH)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(2 * Kwidth, 0);
    self.scrollView.pagingEnabled = YES;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, 150 * KH)];
    //[backView1 sd_setImageWithURL:[self.musician objectForKey:@"BG"]];
    
    [backView1 sd_setImageWithURL:[self.musician objectForKey:@"BG"] placeholderImage:[UIImage imageNamed:@"zhanweitu.jgp"]];
    
    
    [self.scrollView addSubview:backView1];
    [self.view addSubview:self.scrollView];
    //[self.collectionView addSubview:self.scrollView];
    [backView1 release];
    
    UIImageView *backView2 = [[UIImageView alloc]initWithFrame:CGRectMake(Kwidth, 0, Kwidth, 150 * KH)];
    //[backView2 sd_setImageWithURL:[self.musician objectForKey:@"BG"]];
    [backView2 sd_setImageWithURL:[self.musician objectForKey:@"BG"] placeholderImage:[UIImage imageNamed:@"zhanweitu.jgp"]];
    [self.scrollView addSubview:backView2];
    [self.view addSubview:self.scrollView];
    [backView2 release];
    
    UIImageView *headPic = [[UIImageView alloc]initWithFrame:CGRectMake(30 * KW, 25 * KH, 60 * KW, 60 * KW)];
    //[headPic sd_setImageWithURL:[self.musician objectForKey:@"I"]];
    [headPic sd_setImageWithURL:[self.musician objectForKey:@"I"] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    headPic.layer.cornerRadius = 30 * KW;
    headPic.layer.masksToBounds = YES;
    [self.scrollView addSubview:headPic];
    [headPic release];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100 * KW, 40 * KH, 140 * KW, 30 * KH)];
    nameLabel.text = [self.musician objectForKey:@"NN"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:nameLabel];
    [nameLabel release];
    
    UIImageView *sex = [[UIImageView alloc]initWithFrame:CGRectMake(225 * KW, 45 * KH, 25 * KW, 25 * KH)];

    if ([[NSString stringWithFormat:@"%@",[self.musician objectForKey:@"SX"] ] isEqualToString:@"0"]) {
        sex.image = [UIImage imageNamed:@"iconfont-nan"];
        
    }
    else if ([[NSString stringWithFormat:@"%@",[self.musician objectForKey:@"SX"] ] isEqualToString:@"1"]){
        
        sex.image = [UIImage imageNamed:@"iconfont-nv"];
        
    }
    [self.scrollView addSubview:sex];
    [sex release];
    
    UILabel *care = [[UILabel alloc]initWithFrame:CGRectMake(116 * KW, 105 * KH, 40 * KW, 20 * KH)];
    care.font = [UIFont systemFontOfSize:13];
    care.textColor = [UIColor whiteColor];
    care.text = @"关注";
    [self.scrollView addSubview:care];
    [care release];
    
    
    UILabel *careNumber = [[UILabel alloc]initWithFrame:CGRectMake(122 * KW, 120 * KH, 40 * KW, 20 * KH)];
    careNumber.font = [UIFont systemFontOfSize:13];
    careNumber.text = [NSString stringWithFormat:@"%@",[self.musician objectForKey:@"TFD"] ];
    careNumber.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:careNumber];
    [careNumber release];
    
    UILabel *fans = [[UILabel alloc]initWithFrame:CGRectMake(244 * KW, 105 * KH, 40 * KW, 20 * KH)];
    fans.font = [UIFont systemFontOfSize:13];
    fans.textColor = [UIColor whiteColor];
    fans.text = @"粉丝";
    [self.scrollView addSubview:fans];
    [fans release];
    
    
    UILabel *fansNumber = [[UILabel alloc]initWithFrame:CGRectMake(242 * KW, 120 * KH, 60 * KW, 20 * KH)];
    fansNumber.textColor = [UIColor whiteColor];
    fansNumber.font = [UIFont systemFontOfSize:12];
    fansNumber.text = [NSString stringWithFormat:@"%@",[self.musician objectForKey:@"TFS"]];
    [self.scrollView addSubview:fansNumber];
    [fansNumber release];
    
    
    UILabel *brief = [[UILabel alloc]initWithFrame:CGRectMake(30 * KW + Kwidth, 10 * KH, Kwidth - 2 * 30 * KW, 80 *KH)];
    brief.numberOfLines = 4;
    if ([[NSNull null]isEqual:[self.musician objectForKey:@"M"]]) {
        brief.text = @"简介: 暂无";
    }else{
        
        brief.text = [NSString stringWithFormat:@"简介: %@",[self.musician objectForKey:@"M"]];
    }
    
    brief.textColor = [UIColor whiteColor];
    brief.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:brief];
    [brief release];
    
    
    UILabel *city = [[UILabel alloc]initWithFrame:CGRectMake(30 * KW + Kwidth, 76 * KH, 150 * KW, 20 * KH)];
    city.textColor = [UIColor whiteColor];
    city.font = [UIFont systemFontOfSize:12];
    city.text = [NSString stringWithFormat:@"城市: %@",[self.musician objectForKey:@"C"]];
    [self.scrollView addSubview:city];
    [city release];
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Kwidth / 2 - 20 * KW, 165 * KH, 30 * KW, 10 * KH)];
    self.pageControl.numberOfPages = 2;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    [_pageControl release];
    
    
    [_scrollView release];
    
}





#pragma mark 改变page
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = self.scrollView.contentOffset.x/Kwidth;
    
        
        //动画效果
        [UIView animateWithDuration:0.5 animations:^{
            //(i * Kwidth / 2, 217 * KH, Kwidth / 2, 40 *KH);
            
            self.animation.frame = CGRectMake(self.collectionView.contentOffset.x/Kwidth * Kwidth / 2, 217 * KH, Kwidth / 2, 40 * KH);
            
            
            
        }];
        
        

    
    
}

-(void)changePage:(UIPageControl *)page{
    
    
    self.scrollView.contentOffset = CGPointMake(Kwidth * page.currentPage, 0);
    
    
}

#pragma mark 设置标题
-(void)taketitle{
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];

    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = [self.musician objectForKey:@"NN"];

}

//返回按钮
-(void)cancel:(UIBarButtonItem *)sender{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
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
