//
//  RadioViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/19.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioList.h"
#import "LCYNewWorking.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "LabelLine.h"
#import "RadioListTableViewCell.h"
#import "SDCycleScrollView.h"
#import "OneRadioViewController.h"
#import "MJRefresh.h"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>


//全部电台数组
@property(nonatomic,retain)NSMutableArray *radioListArray;
//轮播图数组
@property(nonatomic,retain)NSMutableArray *LBTArray;
//精选电台
@property(nonatomic,retain)NSMutableArray *selectionArray;
//底层视图
@property(nonatomic,retain)UITableView *tableView;
//轮播图
@property(nonatomic,retain)UIView *LBTview;

@property(nonatomic,assign)NSInteger temp;

@end

@implementation RadioViewController

-(void)dealloc{
    
    [_tableView release];
    [_radioListArray release];
    [_LBTArray release];
    [_selectionArray release];
    [super dealloc];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.radioListArray = [NSMutableArray array];
    self.LBTArray = [NSMutableArray array];
    self.selectionArray = [NSMutableArray array];
    
    self.navigationItem.title = @"电台";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , Kwidth, Kheight) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(350 * KH, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //解析数据
    
    //电台列表
    NSString *Radiostr = @"http://api2.pianke.me/ting/radio";
    
    NSDictionary *Radiodic = [NSDictionary dictionaryWithObjectsAndKeys:@"auth=&client=1&deviceid=E67F22E8-A87F-45D4-A3F3-5182C1585430&version=3.0.6",@"auth", nil];
    
    [LCYNewWorking PostDataWithURL:Radiostr dic:Radiodic success:^(id responseObject) {
                
        self.selectionArray = [[responseObject objectForKey:@"data"] objectForKey:@"hotlist"];
        
        self.LBTArray = [[responseObject objectForKey:@"data"] objectForKey:@"carousel"];
        
        //调用轮播图方法
        [self repeats];
        
        [self hotlist];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    NSString *radioList = @"http://api2.pianke.me/ting/radio_list";
    NSString *key = [NSString stringWithFormat:@"&client=2&deviceid=E67F22E8-A87F-45D4-A3F3-5182C1585430&limit=9&start=9&version=3.0.6"];

    NSDictionary *listDic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"auth", nil];
    
    [LCYNewWorking PostDataWithURL:radioList dic:listDic success:^(id responseObject) {

        [self.radioListArray addObjectsFromArray: [[responseObject objectForKey:@"data"] objectForKey:@"list"]];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        
        static int sum = 9;
        sum += 9;
        
        NSString *str = [NSString stringWithFormat:@"%d", sum];
        
        NSDictionary *dic = @{@"start":@"9", @"client":@"2", @"limit":str};
        
        [LCYNewWorking PostDataWithURL:@"http://api2.pianke.me/ting/radio_list" dic:dic success:^(id responseObject) {
            
            //NSLog(@"%ld", ((NSArray *)[[responseObject objectForKey:@"data"]objectForKey:@"list"]).count);
            NSInteger j = ((NSArray *)[[responseObject objectForKey:@"data"]objectForKey:@"list"]).count;
            int i = 0;
            for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                if (i >= sum - 9 && i < j){

                    [self.radioListArray addObject:dic];
                }
                
                i++;
                
            }
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@", error);
        }];
        
        
    }];
    
    
    [self.view addSubview:self.tableView];
    [_tableView release];
    
}

#pragma mark 推荐页轮播图
-(void)repeats{
    
    
    SDCycleScrollView *scrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, -350 * KH, Kwidth, 180 * KH)];
    scrollView.delegate = self;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.LBTArray) {
        NSString *str = [dic objectForKey:@"img"];
        
        [array addObject:str];
    }
    
    scrollView.imageURLStringsGroup = array;
    [self.tableView addSubview:scrollView];
    
    [scrollView release];
    
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
}


#pragma mark 精选电台方法
-(void)hotlist{
    
    
    LabelLine *selectionLL = [[LabelLine alloc]initWithFrame:CGRectMake(0, -160 * KH, Kwidth, 12)];
    selectionLL.label.text = @"精选电台·Hot List";
    [self.tableView addSubview:selectionLL];
    [selectionLL release];
    
    
    LabelLine *allRadioLL = [[LabelLine alloc]initWithFrame:CGRectMake(0, -10, Kwidth, 12)];
    allRadioLL.label.text = @"全部电台·All Radios";
    [self.tableView addSubview:allRadioLL];
    [allRadioLL release];

    for (int i = 0; i < 3; i++) {
        
        UIImageView *selectionView = [[UIImageView alloc]initWithFrame:CGRectMake(5 * KW + 123 * KW * i, -142 * KH, 119 * KW, 120 * KH)];
        selectionView.tag = 10 + i;
        NSString *str = [self.selectionArray[i]objectForKey:@"coverimg" ];
        [selectionView sd_setImageWithURL:[NSURL URLWithString:str]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
        
        [self.tableView addSubview:selectionView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelection:)];
        selectionView.userInteractionEnabled = YES;
        [selectionView addGestureRecognizer:tap];
        
        [selectionView release];
        
    }

}

//精选电台手势
-(void)clickSelection:(UITapGestureRecognizer *)tap{
    

    OneRadioViewController *oneView = [[OneRadioViewController alloc]init];
    oneView.key = [self.selectionArray[tap.view.tag - 10] objectForKey:@"radioid"];
    [self.navigationController pushViewController:oneView animated:YES];
    [oneView release];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.radioListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"radioList";
    
    RadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[RadioListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
        
    }
    
    RadioList *radioList = [RadioList radioListWithDcitionary:self.radioListArray[indexPath.row]];
    
    cell.radioList = radioList;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95 * KH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OneRadioViewController *oneView = [[OneRadioViewController alloc]init];
    
    oneView.key = [self.radioListArray[indexPath.row] objectForKey:@"radioid"];

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
