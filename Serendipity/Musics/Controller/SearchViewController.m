//
//  SearchViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "SearchViewController.h"
#import "MusicViewController.h"
#import "LCYNewWorking.h"
#import "AFNetworking.h"
#import "SearchTableViewCell.h"
#import "SearchList.h"
#import "PlayingViewController.h"
#import "MJRefresh.h"
#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UISearchBar *searchBar;
//搜索结果数组
@property(nonatomic,retain)NSMutableArray *searchArray;
//关键词数组
@property(nonatomic,retain)NSArray *keyWordArray;

@property(nonatomic,retain)UITableView *tableView;
//底层视图
@property(nonatomic,retain)UIView *firstView;

@property(nonatomic,retain)NSDictionary *dic;

@property(nonatomic,retain)UIBarButtonItem *button;

@property(nonatomic,retain)PlayingViewController *playView;

@end

@implementation SearchViewController

-(void)dealloc{
    
    [_searchBar release];
    [_searchArray release];
    [_keyWordArray release];
    [_tableView release];
    [_playView release];
    [_dic release];
    [_button release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //右上角取消按钮
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playView = [PlayingViewController defaultPlayingViewController];
    self.searchArray = [NSMutableArray array];
    self.keyWordArray = [NSArray array];
    
    self.button = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [self.button setTintColor:[UIColor greenColor]];

    
    self.navigationItem.rightBarButtonItem = self.button;

    self.navigationItem.hidesBackButton = YES;
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.frame = CGRectMake(10 * KW, 7 * KH, 320 * KW, 30 * KH);
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    self.searchBar.placeholder = @"搜索歌曲/用户/歌单";
    
    self.searchBar.delegate = self;
    
    [self.searchBar becomeFirstResponder];
    
    [_searchBar release];
    
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Kwidth, Kheight - 64)];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstView];
    
    UIView *keyWordView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, 35 * KH)];
    keyWordView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.firstView addSubview:keyWordView];
    [keyWordView release];
    
    UILabel *keyWord = [[UILabel alloc]initWithFrame:CGRectMake(10 * KW, 3 * KH, 200 * KW, 30 * KH)];
    keyWord.text = @"搜索关键词";
    [keyWordView addSubview:keyWord];
    

    //搜索关键词
    NSString *str = @"http://mobileapi.5sing.kugou.com/song/hottag?limit=20&version=5.8.2";
    [LCYNewWorking GetDataWithURL:str dic:nil success:^(id responseObject) {
        
        self.keyWordArray = [responseObject objectForKey:@"data"];
        
        NSInteger a = self.keyWordArray.count / 3;
        if (self.keyWordArray.count % 3 != 0) {
            a += 1;
        }
      
        for (int i = 0; i < a; i++) {
            for (int j = 0; j < 3; j++) {
                
                UIButton *key = [UIButton buttonWithType:UIButtonTypeCustom];
                key.frame = CGRectMake(j * 115 * KW + 20 * KW, i * 35 * KH + 40 * KH, 100 * KW, 30 * KH);
                key.layer.borderColor = [UIColor grayColor].CGColor;
                key.layer.borderWidth = 0.5;
                key.layer.cornerRadius = 5 * KW;
                key.tag = i * 3 + j + 1;
                key.layer.masksToBounds = YES;
                
                [key setTitle:[self.keyWordArray[i * 3 + j] objectForKey:@"Name"] forState:UIControlStateNormal];
                key.titleLabel.font = [UIFont systemFontOfSize:12 * KW];
                [key setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [key addTarget:self action:@selector(searchKey:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.firstView addSubview:key];
            }
            
        }
        
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    [_firstView release];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight ) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [_tableView release];
    
    
    //加载
    [self.tableView addFooterWithCallback:^{
       
        [self returnSearch:40];
        
        [self.tableView footerEndRefreshing];
        
    }];
    
    
    [self.view bringSubviewToFront:self.firstView];
    
}


#pragma mark 搜索方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self returnSearch:20];
    [self.searchBar resignFirstResponder];
    
}

-(void)returnSearch:(NSInteger)searchNumber{
    
    NSString *searchtext = self.searchBar.text;
    
    NSString *searchurl1 = [searchtext stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:searchtext]];
    
    NSString *searchurl = [searchurl1 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/search/search?k=%@&t=0&filterType=1&sortType=0&ps=%ld&pn=1&version=5.8.2",searchurl,searchNumber];
    
    [LCYNewWorking GetDataWithURL:urlStr dic:nil success:^(id responseObject) {
        
        self.searchArray = [[responseObject objectForKey:@"data"] objectForKey:@"songArray"];
        
        
        if (self.searchArray.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无结果" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
       [self.tableView reloadData];
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [self.view bringSubviewToFront:self.tableView];
    
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchBar.text isEqualToString:@""]) {
        [self.view bringSubviewToFront:self.firstView];
        
    }
    
}

#pragma mark 关键词搜索
-(void)searchKey:(UIButton *)sender{
    
    NSString *str = [[self.keyWordArray[sender.tag - 1] objectForKey:@"Name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:[self.keyWordArray[sender.tag - 1] objectForKey:@"Name"]]];
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *url = [NSString stringWithFormat:@"http://goapi.5sing.kugou.com/search/search?k=%@&t=0&filterType=1&sortType=0&ps=20&pn=1&version=5.8.2",urlStr];

    
    [LCYNewWorking GetDataWithURL:url dic:nil success:^(id responseObject) {
        
        self.searchArray = [[responseObject objectForKey:@"data"] objectForKey:@"songArray"];
    
        [self.tableView reloadData];
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [self.view bringSubviewToFront:self.tableView];
    
    self.searchBar.text = [self.keyWordArray[sender.tag - 1] objectForKey:@"Name"];
    
    [self.searchBar resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"search";
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    SearchList *searchList = [SearchList searchWithDictionary:self.searchArray[indexPath.row]];
    
    cell.searchList = searchList;
    
    NSString *string = searchList.songName;
    NSString *searchStr = self.searchBar.text;
    NSRange range = [string rangeOfString:searchStr];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    [cell.songName  setAttributedText:attStr];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"http://mobileapi.5sing.kugou.com/song/get?songtype=yc&songid=%@",[self.searchArray[indexPath.row] objectForKey:@"songId"]];
    
    NSString *str1 = [str stringByAppendingString:@"&songfields=ID%2CSN%2CFN%2CSK%2CSW%2CSS%2CST%2CSI%2CCT%2CM%2CS%2CZQ%2CWO%2CZC%2CHY%2CYG%2CCK%2CD%2CRQ%2CDD%2CE%2CR%2CRC%2CSG%2CC%2CCS%2CLV%2CLG%2CSY%2CUID%2CPT%2CSCSR%2CSC&userfields=ID%2CNN%2CI&version=5.8.2"];
    NSLog(@"%@",str1);
    
    
    [LCYNewWorking GetDataWithURL:str1 dic:nil success:^(id responseObject) {
        
        self.dic = [responseObject objectForKey:@"data"];
        
        self.playView.musicUrl = [self.dic objectForKey:@"FN"];
        
        self.playView.user = [self.dic objectForKey:@"user"];
        
        self.playView.SW = [self.dic objectForKey:@"SW"];
        
        self.playView.SN = [self.dic objectForKey:@"SN"];
        
        [self.navigationController pushViewController:self.playView animated:YES];

    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

//取消按钮方法
-(void)cancel:(UIBarButtonItem *)sender{
    
    MusicViewController *musicView = [[MusicViewController alloc]init];
    
   // musicView.navigationController.navigationBar.hidden = YES;
    
    [self.navigationController pushViewController:musicView animated:YES];
    
    [self.searchBar resignFirstResponder];
   
    [musicView release];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    self.searchBar.hidden = NO;
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
