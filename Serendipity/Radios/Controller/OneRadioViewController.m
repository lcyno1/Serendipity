//
//  OneRadioViewController.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/4.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "OneRadioViewController.h"
#import "LCYNewWorking.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "OneRadioTableView.h"
#import "OneProViewController.h"
#import "PlayingViewController.h"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface OneRadioViewController ()<UITableViewDataSource,UITableViewDelegate>
//用户信息
@property(nonatomic,retain)NSDictionary *radioinfo;
//电台数组
@property(nonatomic,retain)NSMutableArray *radioList;

@end

@implementation OneRadioViewController

-(void)dealloc{
    
    [_key release];
    [_radioinfo release];
    [_radioList release];
    [_tableView release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backView:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.radioinfo = [NSDictionary dictionary];
    self.radioList = [NSMutableArray array];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -44 * KH , Kwidth, Kheight + 49 * KH ) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(285 * KH, 0, 0, 0);
    
    [self headView];
    [self.view addSubview:self.tableView];
    [_tableView release];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.radioList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"radio";
    
    OneRadioTableView *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[OneRadioTableView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    cell.titleLabel.text = [self.radioList[indexPath.row] objectForKey:@"title"];
    //[cell.picture sd_setImageWithURL:[NSURL URLWithString:[self.radioList[indexPath.row] objectForKey:@"coverimg"]]];
    
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:[self.radioList[indexPath.row] objectForKey:@"coverimg"]] placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%@",[self.radioList[indexPath.row] objectForKey:@"musicVisit"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    playView.SN = [self.radioList[indexPath.row]objectForKey:@"title"];
    playView.SW = @"暂无歌词";
    playView.musicUrl = [self.radioList[indexPath.row] objectForKey:@"musicUrl"];
    playView.user = [NSDictionary dictionaryWithObjectsAndKeys:[[[self.radioList[indexPath.row] objectForKey:@"playInfo"] objectForKey:@"authorinfo"] objectForKey:@"uname"],@"NN",[[[self.radioList[indexPath.row] objectForKey:@"playInfo"] objectForKey:@"authorinfo"] objectForKey:@"icon"],@"I", nil];
    [self.navigationController pushViewController:playView animated:YES];
    
    
}



-(void)headView{
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, -285 * KH, Kwidth, 285 * KH)];
    head.userInteractionEnabled = YES;
    [self.tableView addSubview:head];
    
    
    UIImageView *PKimage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * KW, 217 * KH, 25 * KW, 25 * KH)];
    PKimage.backgroundColor = [UIColor grayColor];
    PKimage.layer.cornerRadius = 12.5;
    PKimage.layer.masksToBounds = YES;
    [head addSubview:PKimage];
    
    UILabel *PKlabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * KW, 222 * KH, 100 * KW, 20 * KH)];
    PKlabel.font = [UIFont systemFontOfSize:13 * KH];
    PKlabel.textColor = [UIColor grayColor];
    [head addSubview:PKlabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40 * KH, Kwidth, 165 * KH)];
    [head addSubview:imageView];
    
    UIImageView *LBimage = [[UIImageView alloc]initWithFrame:CGRectMake(285 * KW, 222 * KH, 15 * KW, 15 * KH)];
    LBimage.image = [UIImage imageNamed:@"iconfont-laba-2"];
    [head addSubview:LBimage];
    [LBimage release];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(305 * KW, 216 * KH, 70 * KW, 30 * KH)];
    numberLabel.textColor = [UIColor grayColor];
    numberLabel.font = [UIFont systemFontOfSize:12 * KW];
    [head addSubview:numberLabel];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * KW, 250 * KH, 300 * KW, 30 * KH)];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:14 * KW];
    [head addSubview:descLabel];
    
    
    NSString *str = @"http://api2.pianke.me/ting/radio_detail";

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.key,@"radioid",@"0",@"start",@"2",@"client",@"10",@"limit", nil];
    //NSLog(@"%@",self.key);
    [LCYNewWorking PostDataWithURL:str dic:dic success:^(id responseObject) {
        
        self.radioinfo = [[responseObject objectForKey:@"data"] objectForKey:@"radioInfo"];
        
        self.radioList = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.radioinfo objectForKey:@"coverimg"]]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
        
        [PKimage sd_setImageWithURL:[NSURL URLWithString:[[self.radioinfo objectForKey:@"userinfo"] objectForKey:@"icon"]]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
        PKlabel.text = [[self.radioinfo objectForKey:@"userinfo"] objectForKey:@"uname"];
        numberLabel.text = [NSString stringWithFormat:@"%@",[self.radioinfo objectForKey:@"musicvisitnum"] ];
        descLabel.text = [self.radioinfo objectForKey:@"desc"];
        
        UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
        

        NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
        
        self.navigationController.navigationBar.titleTextAttributes = dict;
        
        self.title = [self.radioinfo objectForKey:@"title"];

        
        
         [self.tableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
   


    [descLabel release];
    [numberLabel release];
    [imageView release];
    [PKimage release];
    [PKlabel release];
    [head release];
    
}

-(void)backView:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
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
