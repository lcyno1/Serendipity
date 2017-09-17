//
//  MineSongViewController.m
//  Serendipity
//
//  Created by 李重阳 on 16/1/8.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "MineSongViewController.h"
#import "MineSongTableViewCell.h"
#import "MusicDatabase.h"
#import "PlayingViewController.h"
#import "MusicDatabase.h"

@interface MineSongViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *musicArray;

@end

@implementation MineSongViewController

-(void)dealloc{
    
    [_tableView release];
    [_musicArray release];
    [super dealloc];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.title = @"我的歌单";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    //self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1350876041373"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    self.musicArray = [NSArray array];
//    
//    MusicDatabase *musicDatabase = [MusicDatabase musicDatabase];
//    
//    self.musicArray = [musicDatabase selectAllMusic];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"1350876041373.jpg"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    [imageView addSubview:self.tableView];
    [imageView release];
    [_tableView release];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.musicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"music";
    
    MineSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[MineSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.songName.text = [self.musicArray[indexPath.row] objectForKey:@"SN"];
    cell.userName.text = [self.musicArray[indexPath.row] objectForKey:@"userName"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicDatabase *dataBase = [MusicDatabase musicDatabase];
    
    NSArray *array = [NSArray array];
    array = [dataBase selectAllMusic];
    
    NSDictionary *dic = array[indexPath.row];
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    playView.SN = [dic objectForKey:@"SN"];
    playView.SW = [dic objectForKey:@"SW"];
    playView.musicUrl = [dic objectForKey:@"musicUrl"];
    playView.user = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"userName"],@"NN",[dic objectForKey:@"picture"],@"I", nil];

    [self.navigationController pushViewController:playView animated:YES];
    
}


-(void)back:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.musicArray = [NSMutableArray array];
    
    MusicDatabase *musicDatabase = [MusicDatabase musicDatabase];
    
    self.musicArray = [[musicDatabase selectAllMusic]mutableCopy];
    
    if (self.musicArray.count == 0) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        
    }
    
    [self.tableView reloadData];
}

//************************* 编辑单元格 ******************//
#pragma mark 右边按钮处于编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
        
    }else
    {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    }
    
}

#pragma mark 指定某一行是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 指定编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 提交编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MusicDatabase *dataBase = [MusicDatabase musicDatabase];
    
    NSArray *array = [NSArray array];
    array = [dataBase selectAllMusic];
    
    NSDictionary *dic = array[indexPath.row];
    
    [self.musicArray removeObject:dic];
    
    [dataBase deleteMusic:dic];
    
    
    [self.tableView reloadData];
    
    
    if (self.musicArray.count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
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
