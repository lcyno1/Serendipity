//
//  MineViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/19.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineSongViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "UIImageView+WebCache.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *mineTableView;

@property(nonatomic,retain)NSArray *titleArray;
@property(nonatomic,retain)NSArray *picArray;

@property(nonatomic,copy)NSString *cachePath;
//是否开启夜间模式
@property(nonatomic,assign)BOOL isNight;


@end

@implementation MineViewController


-(void)dealloc{
    
    [_mineTableView release];
    [_cachePath release];
    [_titleArray release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    self.titleArray = [NSArray array];
    self.picArray = [NSArray array];
    
    self.cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    self.titleArray = @[@"我的收藏",@"分享",@"清除缓存",@"夜间模式"];
    self.picArray = @[[UIImage imageNamed:@"iconfont-shoucanggedan"],[UIImage imageNamed:@"icon_sinaWeibo"],[UIImage imageNamed:@"iconfont-qingchuhuancun"],[UIImage imageNamed:@"iconfont-yejianzhuanhuan"]];
    
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.mineTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    UIView *foot =[[UIView alloc]initWithFrame:CGRectZero];
    [self.mineTableView setTableFooterView:foot];
    
    [self.view addSubview:self.mineTableView];
    [_mineTableView release];
    
   
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"mine";
    
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
        
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.picture.image = self.picArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    MineSongViewController *songView = [[MineSongViewController alloc]init];
    [self.navigationController pushViewController:songView animated:YES];
    [songView release];
    }
    if (indexPath.row == 1) {
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                         images:@[[UIImage imageNamed:@"AppIcon60x60"]]
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
        
        //进行分享
        [ShareSDK share:SSDKPlatformTypeSinaWeibo
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     }];
                     [alertView addAction:ensure];
                     //presentViewController为当前视图控制器
                     [self presentViewController:alertView animated:YES completion:^{
                         
                     }];
                     
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     }];
                     [alertView addAction:ensure];
                     [self presentViewController:alertView animated:YES completion:^{
                         
                     }];
                     
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     }];
                     [alertView addAction:ensure];
                     
                     [self presentViewController:alertView animated:YES completion:^{
                         
                     }];
                     break;
                 }
                 default:
                     break;
             }
             
         }];
    }
    if (indexPath.row == 2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前缓存%.2fM,确定删除？", [MineViewController folderSizeAtPath:self.cachePath] / 1024 / 1024] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MineViewController clearCache:self.cachePath];
            [self.mineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:ensure];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        
        
    }
    if (indexPath.row == 3) {
        
        NSString *dayOrNight = @"";
        
        if (self.isNight == NO) {
            self.isNight = YES;
            dayOrNight = @"night";
        }
        else{
            self.isNight = NO;
            dayOrNight = @"day";
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dayOrNight,@"isNight", nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dayNight" object:self userInfo:dic];
        
        
    }
    
    
}

//***************** *************** 计算、清除缓存*************//
#pragma mark 计算单个文件大小
+(CGFloat)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:path]) {
        
        CGFloat size = [fileManger attributesOfItemAtPath:path error:nil].fileSize;
        
        return size / 1024.0 /1024.0;
    }
    return 0;
}


#pragma mark 计算目录大小
+ (CGFloat)folderSizeAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    CGFloat folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [MineViewController fileSizeAtPath:absolutePath];
        }
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize;
    }
    return 0;
}

#pragma mark 清理缓存文件
+ (void)clearCache:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.mineTableView reloadData];
    
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
