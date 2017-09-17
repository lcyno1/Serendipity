//
//  AppDelegate.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/19.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicViewController.h"
#import "MusicianViewController.h"
#import "RadioViewController.h"
#import "MineViewController.h"
#import "MusicDatabase.h"
#import "PlayingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "WXApi.h"


@interface AppDelegate ()<UIScrollViewDelegate,WXApiDelegate>

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)UIPageControl *pageControl;

@end

@implementation AppDelegate

-(void)dealloc{
    
    [_window release];
    [_scrollView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dayNight" object:nil];
    [super dealloc];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    
    //建立4个主界面 关联tabBar
    
    MusicViewController *musicView = [[MusicViewController alloc]init];
    UINavigationController *musicNav = [[UINavigationController alloc]initWithRootViewController:musicView];
    musicNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"乐库" image:[[UIImage imageNamed:@"iconfont-yinle-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-yinle-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    MusicianViewController *musicianView = [[MusicianViewController alloc]init];
    UINavigationController *musicianNav = [[UINavigationController alloc]initWithRootViewController:musicianView];
    musicianNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"音乐人" image:[[UIImage imageNamed:@"iconfont-yinleren"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-yinleren-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    RadioViewController *radioView = [[RadioViewController alloc]init];
    UINavigationController *radioNav = [[UINavigationController alloc]initWithRootViewController:radioView];
    radioNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"电台" image:[[UIImage imageNamed:@"iconfont-diantai"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-diantai-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    MineViewController *mineView = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineView];
    mineNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"iconfont-wode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-wode-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    //创建tabBar

    UITabBarController *tabBar = [[UITabBarController alloc]init];
    
    tabBar.viewControllers = @[musicNav,musicianNav,radioNav,mineNav];
    
    self.window.rootViewController = tabBar;
    

    //创建数据库
    MusicDatabase *musicDatabase = [MusicDatabase musicDatabase];
    [musicDatabase openMusicDatabase];
    [musicDatabase createTable];
    NSDictionary *dic = [musicDatabase historyAllMusic].lastObject;
    PlayingViewController *playView = [PlayingViewController defaultPlayingViewController];
    playView.SN = [dic objectForKey:@"SN"];
    playView.SW = [dic objectForKey:@"SW"];
    playView.musicUrl = [dic objectForKey:@"musicUrl"];
    playView.user = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"userName"],@"NN",[dic objectForKey:@"picture"],@"I", nil];
   
   
    
    [musicView release];
    [musicNav release];
    [musicianView release];
    [musicianNav release];
    [radioView release];
    [radioNav release];
    [mineView release];
    [mineNav release];
    [tabBar release];
    [_window release];
    
    //创建数据库
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isNight:) name:@"dayNight" object:nil];
    
    
    [self setUpShareSDK];
    
    //[WXApi registerApp:@"wxd930ea5d5a258f4f"];
    
    //向微信注册
    //[WXApi registerApp:@"wx4868b35061f87885" withDescription:@"demo 2.0"];
    [WXApi registerApp:@"wx90decb1bc9f03428"];
    
    //AVPlayer进入后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    //[[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
    
    //引导页
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"guidePage.txt"];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!isExist) {
        
        NSString *string = @"引导页";
        [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.window.frame];
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor cyanColor];
        self.scrollView.contentSize = CGSizeMake(self.window.frame.size.width * 4, self.window.frame.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.window addSubview:self.scrollView];
        
        //在滚动视图上创建UIImageView
        for (int i = 0; i < 4; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.window.frame.size.width, 0, self.window.frame.size.width, self.window.frame.size.height)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ydy%d.jpg",i]];
            imageView.tag = i + 100;
            imageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imageView];
            
            if (i == 3) {
                UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                joinBtn.frame = CGRectMake(0, 0, self.window.frame.size.width / 3, 40 *KH);
                joinBtn.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height - 50 *KH);
                [joinBtn setTitle:@"立即体验" forState:UIControlStateNormal];
                joinBtn.backgroundColor = [UIColor colorWithRed:0.83 green:0.99 blue:0.84 alpha:1];
                [joinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [joinBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
                
                joinBtn.alpha = 0.7;
                joinBtn.layer.cornerRadius = 5;
                joinBtn.layer.masksToBounds = YES;
                
                [joinBtn addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [imageView addSubview:joinBtn];
                
            }
            
            [imageView release];
            
        }
        //创建pagecontrol
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width / 4, 40 * KH)];
        self.pageControl.center = CGPointMake(self.window.frame.size.width / 2, 50 * KH);
        self.pageControl.numberOfPages = 4;
        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        [self.pageControl addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:self.pageControl];
        
        [_pageControl release];
        [_scrollView release];
    }
    
    return YES;
}

- (void)enterAction:(UIButton *)sender
{
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.scrollView.alpha = 0;
        //[self.pageControl removeFromSuperview];
    } completion:^(BOOL finished) {
        
        [self.pageControl removeFromSuperview];
        [self.scrollView removeFromSuperview];
    }];
    
}
- (void)clickAction:(UIPageControl *)pageControl
{
    
    self.scrollView.contentOffset = CGPointMake(pageControl.currentPage * self.window.frame.size.width, 0);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.pageControl.currentPage = scrollView.contentOffset.x / self.window.frame.size.width;
    
}

#pragma 夜间模式

-(void)isNight:(NSNotification *)notification{
    
    if ([[notification.userInfo objectForKey:@"isNight"]isEqualToString:@"night"]) {
        
        self.window.alpha = 0.8;
    }
    else if ([[notification.userInfo objectForKey:@"isNight"]isEqualToString:@"day"]){
        
        self.window.alpha = 1;
    }
}



- (void)setUpShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"e6d43fac90cc"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo)]
                 onImport:nil
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
              
          }];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
