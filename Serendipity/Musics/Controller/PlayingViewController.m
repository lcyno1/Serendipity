//
//  PlayingViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "PlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "UIImageView+WebCache.h"
#import "MusicDatabase.h"
#import "CollectionTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高

typedef enum : NSUInteger {
    sequence = 0,
    shuffle = 1,
    circulate = 2,
} PlayStyle;




@interface PlayingViewController ()<AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WXApiDelegate>



@property(nonatomic,retain)AVPlayer *avPlayer;

@property(nonatomic,retain)AVPlayerLayer *playerLayer;
//音量
@property(nonatomic,retain)UISlider *volumeSlider;

@property(nonatomic,retain)NSTimer *timer;
//播放进度
@property(nonatomic,retain)UISlider *songSlide;
//歌曲总时间
@property(nonatomic,retain)UILabel *allTime;
//播放时间
@property(nonatomic,retain)UILabel *thistime;
//播放按钮
@property(nonatomic,retain)UIButton *playButton;
//歌词视图
@property(nonatomic,retain)UIScrollView *wordView;
//歌词高度
@property(nonatomic,assign)CGRect result;
//是否在播放
@property(nonatomic,assign)BOOL isPlaying;
//是否静音
@property(nonatomic,assign)BOOL openVoice;
//历史播放
@property(nonatomic,retain)NSMutableArray *history;
//用户头像
@property(nonatomic,retain)UIImageView *headPic;
//用户名
@property(nonatomic,retain)UILabel *userName;
//歌词
@property(nonatomic,retain)UILabel *word;
//数据库字典
@property(nonatomic,retain)NSMutableDictionary *databaseDic;
//是否收藏
@property(nonatomic,assign)BOOL collection;
//收藏按钮
@property(nonatomic,retain)UIButton *collecButton;
//底层滑动
@property(nonatomic,retain)UIScrollView *scrollView;
//收藏的歌曲
@property(nonatomic,retain)NSMutableArray *collectionArray;
//歌单tableView
@property(nonatomic,retain)UITableView *songTableView;
//上一首,下一首
@property(nonatomic,retain)UIButton *nextButton;
@property(nonatomic,retain)UIButton *lastButton;
@property(nonatomic,retain)UIPageControl *pageControl;
//随机播放
@property(nonatomic,assign)PlayStyle playStyle;
//随机按钮
@property(nonatomic,retain)UIButton *styleButton;
//分享页
@property(nonatomic,retain)UIView *shairView;



@end

@implementation PlayingViewController

-(void)dealloc{

    [_SN release];
    [_SW release];
    [_user release];
    [_avPlayer release];
    [_musicUrl release];
    [_playerLayer release];
    [_volumeSlider release];
    [_timer release];
    [_songSlide release];
    [_allTime release];
    [_thistime release];
    [_playButton release];
    [_wordView release];
    [_history release];
    [_headPic release];
    [_userName release];
    [_word release];
    [_databaseDic release];
    [_collecButton release];
    [_scrollView release];
    [_collectionArray release];
    [_songTableView release];
    [_lastButton release];
    [_nextButton release];
    [_pageControl release];
    [_styleButton release];
    [_shairView release];
    [super dealloc];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = self.SN;
    
    self.history = [NSMutableArray array];
    
    self.collectionArray = [NSMutableArray array];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(Kwidth, -64, Kwidth, Kheight)];
    background.userInteractionEnabled = YES;
    background.image = [UIImage imageNamed:@"1350876041373.jpg"];
    background.tag = 100;
    
    UIImageView *songGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, Kwidth, Kheight)];
    songGround.userInteractionEnabled = YES;
    songGround.image = [UIImage imageNamed:@"1350876041373.jpg"];
    
    //底层
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight)];
    self.scrollView.contentSize = CGSizeMake(2 * Kwidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentOffset = CGPointMake(Kwidth, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:background];
    [self.scrollView addSubview:songGround];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Kwidth / 2 - 15 * KW, 545 * KH, 30 * KW, 10 * KH)];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 2;
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [self.view bringSubviewToFront:self.pageControl];
    [self.view addSubview:self.pageControl];
    
    //收藏按钮
    self.collecButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collecButton.frame = CGRectMake(270 * KW, 520 * KH, 30 * KW, 30 * KH);
    [self.collecButton setImage:[UIImage imageNamed:@"iconfont-xin"] forState:UIControlStateNormal];
    [self.collecButton addTarget:self action:@selector(clickCollection:) forControlEvents:UIControlEventTouchUpInside];
    self.collecButton.tag = 10;
    [background bringSubviewToFront:self.collecButton];
    [background addSubview:self.collecButton];
    

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.playerLayer.frame = CGRectMake(0, 500, 375, 100);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.delegate = self;
    self.avPlayer.volume = 3.0f;
    [self.view.layer addSublayer:self.playerLayer];
    
    //进度条
    self.songSlide = [[UISlider alloc]initWithFrame:CGRectMake(50 * KW, 545 * KH, Kwidth - 50 * 2 * KW, 50 * KH)];
    [self.songSlide setThumbImage:[UIImage imageNamed:@"iconfont-yuan"] forState:UIControlStateNormal];
    
    self.songSlide.tintColor = [UIColor whiteColor];
    
    //总时间 播放时间
    self.allTime = [[UILabel alloc]initWithFrame:CGRectMake(335 * KW, 550 * KH, 50 * KW, 40 * KH)];
    self.allTime.font = [UIFont systemFontOfSize:13 * KW];
    self.allTime.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];

    self.thistime = [[UILabel alloc]initWithFrame:CGRectMake(10 * KW, 550 * KH, 50 * KW, 40 * KH)];
    self.thistime.font = [UIFont systemFontOfSize:13 * KW];
    self.thistime.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.allTime.text = @"00:00";
    self.thistime.text = @"00:00";
    
    [background addSubview:self.allTime];
    [background addSubview:self.thistime];
    [background addSubview:self.songSlide];
    
    [_allTime release];
    [_thistime release];
    [_songSlide release];
    
    //用NSTimer来监控音频播放进度
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress)userInfo:nil repeats:YES];

    //音量开关
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.frame = CGRectMake(310 * KW, 515 * KH, 40 * KW, 40 * KH);
    [voice setImage:[[UIImage imageNamed:@"iconfont-laba2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(voiceOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:voice];
    
    //分享
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(227 * KW, 520 * KH, 25 * KW, 25 * KH);
    [share setImage:[UIImage imageNamed:@"iconfont-601"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:share];

    
    //播放按钮
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setFrame:CGRectMake(Kwidth/2 - 15 * KW, 600 * KH, 30 * KW, 30 * KH)];
    [self.playButton setImage:[[UIImage imageNamed:@"iconfont-iconfontplayerplay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:self.playButton];
    
    //下一曲 上一曲
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(250 * KW, 600 * KH, 30 * KW, 30 * KH);
    [self.nextButton setImage:[UIImage imageNamed:@"iconfont-xiayishou"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:self.nextButton];
    
    self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastButton.frame = CGRectMake(95 * KW, 600 * KH, 30 * KW, 30 * KH);
    [self.lastButton setImage:[UIImage imageNamed:@"iconfont-shangyishou"] forState:UIControlStateNormal];
    [self.lastButton addTarget:self action:@selector(clickLast:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:self.lastButton];
    
    //顺序 随机 循环
    self.styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.styleButton.frame = CGRectMake(30 * KW, 600 * KH, 30 * KW, 30 * KH);
    [self.styleButton setImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateNormal];
    [self.styleButton addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:self.styleButton];
    
    
    //歌词
    self.word = [[UILabel alloc]initWithFrame:CGRectMake(150 , 240, Kwidth - 80 * 2 * KW, 50 * KH)];
    self.wordView = [[UIScrollView alloc]initWithFrame:CGRectMake(95 * KW, 80 * KH, Kwidth - 80 * 2 * KW, 400 * KH)];
    
    [self songWord];
    [_word release];
    [_wordView release];
    
    
    //设置用户信息
    self.headPic = [[UIImageView alloc]initWithFrame:CGRectMake(25 * KW, 470 * KH,60 * KW, 60 * KH)];
    self.headPic.layer.cornerRadius = 30;
    self.headPic.layer.masksToBounds = YES;
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(90 * KW, 500 * KH, 280 * KW, 25 * KH)];
    self.userName.textColor = [UIColor whiteColor];
    
    [self userinfor];
    
    [background addSubview:self.headPic];
    [_headPic release];
    
    [background addSubview:self.userName];
    [_userName release];
    
    
    //收藏歌单
    self.songTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100 * KH, Kwidth, Kheight - 100 * KH) style:UITableViewStylePlain];
    self.songTableView.dataSource = self;
    self.songTableView.delegate = self;
    self.songTableView.backgroundColor = [UIColor clearColor];
    [songGround addSubview:self.songTableView];
    self.songTableView.contentInset = UIEdgeInsetsMake(45 * KH, 0, 0, 0);
    self.songTableView.tag = 20;
    self.songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_songTableView release];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 * KW, -25 * KH, 200 * KW, 20 * KH)];
    numberLabel.text = [NSString stringWithFormat:@"我的歌单"];
    [self.songTableView addSubview:numberLabel];
    [numberLabel release];
    
    [songGround release];
    [background release];
    [_scrollView release];
    
    
    //分享页面
    self.shairView = [[UIView alloc]initWithFrame:CGRectMake(0, 547, Kwidth, 120)];
    self.shairView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shairView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShairView:)];
    [self.shairView addGestureRecognizer:tap];
    self.shairView.userInteractionEnabled = YES;
    self.shairView.hidden = YES;
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(Kwidth / 2 - 25 * KW, 90 * KH, 50 * KW, 30 * KH);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.shairView addSubview:cancelButton];
    
    UIView *cancelLine = [[UIView alloc]initWithFrame:CGRectMake(0, 85 * KH, Kwidth, 0.5)];
    cancelLine.backgroundColor =[UIColor blackColor];
    [self.shairView addSubview:cancelLine];
    [cancelLine release];
    
    UILabel *shareLable = [[UILabel alloc]initWithFrame:CGRectMake(6 * KW, 3 * KH, 100 * KW, 20 * KH)];
    shareLable.text = @"分享到";
    shareLable.textColor = [UIColor grayColor];
    shareLable.font = [UIFont systemFontOfSize:15 * KW];
    [self.shairView addSubview:shareLable];
    [shareLable release];
    
    UIView *shareLine = [[UIView alloc]initWithFrame:CGRectMake(0, 22 * KH, Kwidth, 0.5)];
    shareLine.backgroundColor = [UIColor blackColor];
    [self.shairView addSubview:shareLine];
    [shareLine release];
    
    UIButton *weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    weibo.frame = CGRectMake(15 * KW, 33 * KH, 40 * KW, 40 * KH);
    [weibo setImage:[UIImage imageNamed:@"icon_sinaWeibo"] forState:UIControlStateNormal];
    [weibo addTarget:self action:@selector(clickWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.shairView addSubview:weibo];
    
    UIButton *wechat = [UIButton buttonWithType:UIButtonTypeCustom];
    wechat.frame = CGRectMake(75 * KW, 33 * KH, 40 * KW, 40 * KH);
    [wechat setImage:[UIImage imageNamed:@"icon_login_weixin_normal"] forState:UIControlStateNormal];
    [wechat addTarget:self action:@selector(clickWeichat:) forControlEvents:UIControlEventTouchUpInside];
    [self.shairView addSubview:wechat];
    
    [_shairView release];
}

//播放
- (void)play
{

    if (self.isPlaying == NO) {
        
        [self.avPlayer play];
        [self.playButton setImage:[[UIImage imageNamed:@"iconfont-tingzhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.isPlaying = YES;

    }else{
        
        [self.avPlayer pause];
        [self.playButton setImage:[[UIImage imageNamed:@"iconfont-iconfontplayerplay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.isPlaying = NO;
    }
    
}
#pragma mark下一首上一首
-(void)clickNext:(UIButton *)sender{
    
    if (self.collectionArray.count != 0) {
        
    if (self.playStyle == 0) {
        
    NSInteger temp = [self songPlace] ;

    if (temp + 1 == self.collectionArray.count) {

        temp = 0;
        
    }
    else{
        
        temp += 1;
        
      }
    [self changeSong:temp];
    }
    else if (self.playStyle == 1){
        
        [self changeSong:arc4random()%(self.collectionArray.count )];
        
    }
    else if (self.playStyle == 2){
        
        [self changeSong:[self songPlace]];
        
    }
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    
}
-(void)clickLast:(UIButton *)sender{
    
    if (self.collectionArray.count != 0) {
    
    if (self.playStyle == 0) {
    NSInteger temp = [self songPlace] ;

    if (temp  == 0) {
        temp = self.collectionArray.count - 1;
    }else{
        temp -= 1;
    }
    [self changeSong:temp];
    }
    else if (self.playStyle == 1){
        
        [self changeSong:arc4random()%(self.collectionArray.count )];
    }
    else if (self.playStyle == 2){
        
        [self changeSong:[self songPlace]];
        
    }
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
#pragma mark 当前播放位置
-(NSInteger)songPlace{
    NSInteger temp = 0;
    for (int i = 0; i < self.collectionArray.count; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.collectionArray[i]];
        if ([[dic objectForKey:@"SN"]isEqualToString:self.title]) {
            break;
        }
        temp++;
    }
 
    if (temp == self.collectionArray.count) {
        temp -= 1;
    }
    
    return temp ;
}

#pragma 顺序,随机,循环
-(void)changeStyle:(UIButton *)sender{
    
    if (self.playStyle == 0) {
        self.playStyle = 1;
        [sender setImage:[UIImage imageNamed:@"iconfont-shuffle"] forState:UIControlStateNormal];
    }
    else if (self.playStyle == 1){
        self.playStyle = 2;
        [sender setImage:[UIImage imageNamed:@"iconfont-liebiaoxunhuan"] forState:UIControlStateNormal];
    }else{
        self.playStyle = 0;
        [sender setImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateNormal];
    }
    
}

#pragma 音量开关
-(void)voiceOnOff:(UIButton *)sender{
    
    if (self.openVoice == NO) {
        
        self.avPlayer.volume = 0;
        [sender setImage:[UIImage imageNamed:@"iconfont-jingyin-2"] forState:UIControlStateNormal];
        self.openVoice = YES;
    }else{
        
        self.avPlayer.volume = 3.0f;
        [sender setImage:[UIImage imageNamed:@"iconfont-laba2"] forState:UIControlStateNormal];
        self.openVoice = NO;
    }
    
}

//播放进度条
- (void)playProgress
{

    self.songSlide.value = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    if (CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) == CMTimeGetSeconds(self.avPlayer.currentItem.duration)) {
        //NSLog(@"完了");
        
        NSInteger temp = [self songPlace] ;
        
        if (self.collectionArray.count != 0) {
            
        if (temp + 1 == self.collectionArray.count) {
            
            temp = 0;
        }else{
            temp += 1;
        }
        [self changeSong:temp];
        }else{
            

            [self.avPlayer pause];
        }

    }
    //时间设置
    NSInteger all = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    
    NSInteger this = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    
    NSString *dateLoca = [NSString stringWithFormat:@"%ld",this];
    NSTimeInterval time = [dateLoca doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestr = [formatter stringFromDate:detaildate];
    
    NSString *dateLoca1 = [NSString stringWithFormat:@"%ld",all];
    NSTimeInterval time1 = [dateLoca1 doubleValue];
    NSDate *detaildate1 = [NSDate dateWithTimeIntervalSince1970:time1];
    NSString *timestr1 = [formatter stringFromDate:detaildate1];
    
    self.allTime.text = [NSString stringWithFormat:@"%@",timestr1];
    self.thistime.text = [NSString stringWithFormat:@"%@",timestr];
    [formatter release];
    //歌词自动滑动

    if (all != 0) {
    self.wordView.contentOffset = CGPointMake(0, (this * (self.result.size.height - 400 * KH) / all) * KH);
    }
    
    UIBackgroundTaskIdentifier plTask = 0;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        UIApplication *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        
        if (plTask != UIBackgroundTaskInvalid) {
            
            [app endBackgroundTask:plTask];
        }
        plTask = newTask;

    }
    
}


//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.timer invalidate]; //NSTimer暂停   invalidate  使...无效;

}


#pragma mark 返回 发送通知
-(void)goback:(UIBarButtonItem *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"显示隐藏" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 设置用户信息
-(void)userinfor{
    
    if ([self.user objectForKey:@"I"] == nil) {
        
        [self.headPic sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"UserPortrait"]]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
        
    }else{
        [self.headPic sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"I"]]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    }
    if ([self.user objectForKey:@"NN"] == nil) {
        
        self.userName.text = [NSString stringWithFormat:@"BY: %@",[self.user objectForKey:@"UserName"]];
    }else{
        self.userName.text = [NSString stringWithFormat:@"BY: %@",[self.user objectForKey:@"NN"]];
    }
    
    
}
#pragma mark 设置歌词
-(void)songWord{

    if ([[NSNull null]isEqual:self.SW] || self.SW == nil || [self.SW isEqualToString:@"暂无歌词"]) {

        self.word.text = @"暂无歌词";
        self.word.font = [UIFont systemFontOfSize:18 * KW];
        self.word.textColor = [UIColor whiteColor];
        self.word.frame = CGRectMake(150 * KW, 240 * KH, Kwidth - 80 * 2 * KW, 50 * KH);
        [[self.view viewWithTag:100] addSubview:self.word];
        
    }else{
        //自适应歌词高度
        CGSize size = CGSizeMake(Kwidth - 80 * 2 * KW, MAXFLOAT);
        
        NSDictionary *style = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:18 * KW],NSFontAttributeName, nil];
        
        self.result = [self.SW boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
        
        self.word.frame = CGRectMake(0 , 0, Kwidth - 80 * 2 * KW, self.result.size.height);
        
        self.wordView.contentSize = CGSizeMake(Kwidth - 80 * 2 * KW, self.result.size.height);
        
        
        self.word.text = self.SW;
        self.word.font = [UIFont systemFontOfSize:18 * KW];
        self.word.textColor = [UIColor whiteColor];
        self.word.numberOfLines = -1;
        [self.wordView addSubview:self.word];
        [[self.view viewWithTag:100] addSubview:self.wordView];
        
    }
}
#pragma mark 页面将要出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //self.history.lastObject [self.databaseDic objectForKey:@"SN"]
    if ([self.SN isEqualToString:[self.databaseDic objectForKey:@"SN"]]) {
        NSLog(@"正在播放");
        
        /////////////////
        [self.playButton setImage:[[UIImage imageNamed:@"iconfont-tingzhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
    }else{
         NSLog(@"新歌");
        
        NSURL *playURL = [NSURL URLWithString:self.musicUrl];
        
        AVAsset *musicAsset = [AVURLAsset URLAssetWithURL:playURL options:nil];
        
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:musicAsset];
        
        self.avPlayer = [AVPlayer playerWithPlayerItem:playItem];

        
        self.title = self.SN;
        
        if ([[NSNull null]isEqual:self.SW] || self.SW == nil) {
            self.SW = @"暂无歌词";
        }
        
        [self playProgress];
        [self userinfor];
        [self songWord];
        
    }
    
    //数据库存储
    NSString *userName = [[NSString alloc]init];
    NSString *picture = [[NSString alloc]init];
    
    if ([self.user objectForKey:@"I"] == nil) {

        picture = [self.user objectForKey:@"UserPortrait"];
        
    }else{
       picture = [self.user objectForKey:@"I"];
    }
    
    if ([self.user objectForKey:@"NN"] == nil) {
        
        userName = [self.user objectForKey:@"UserName"];
    }else{
      userName = [self.user objectForKey:@"NN"];
    }
    
    self.databaseDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.SN,@"SN",self.SW,@"SW",self.musicUrl,@"musicUrl",userName,@"userName",picture,@"picture", nil];
    
     MusicDatabase *musicDatabase = [MusicDatabase musicDatabase];
    
    [musicDatabase insertHistory:self.databaseDic];
    
    BOOL collection = [musicDatabase selecMusic:self.SN];
    
    if (collection == YES) {
        
        [self.collecButton setImage:[UIImage imageNamed:@"iconfont-xin-2"] forState:UIControlStateNormal];
        self.collection = YES;
        
    }else{
        [self.collecButton setImage:[UIImage imageNamed:@"iconfont-xin"] forState:UIControlStateNormal];
        self.collection = NO;
        
    }

    self.collectionArray = [[musicDatabase selectAllMusic]mutableCopy];
    self.scrollView.contentOffset = CGPointMake(Kwidth, 0);
    //[self.history addObject:self.SN];
    [self.avPlayer play];
    [self.playButton setImage:[[UIImage imageNamed:@"iconfont-tingzhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    BOOL playingM = YES;
//    self.playingMusic(playingM);

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //进入后台播放控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    //[self becomeFirstResponder];
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    if (event.type == UIEventTypeRemoteControl) {
        
        if (event.subtype == UIEventSubtypeRemoteControlPause) {
            
            NSLog(@"暂停");
            [self.avPlayer pause];
            self.isPlaying = NO;
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){

            NSLog(@"下一曲");
            
            if (self.collectionArray.count != 0) {
            
            if (self.playStyle == 0) {
                
                NSInteger temp = [self songPlace] ;
                
                if (temp + 1 == self.collectionArray.count) {
                    
                    temp = 0;
                }else{
                    temp += 1;
                }
                [self changeSong:temp];
            }
            else if (self.playStyle == 1){
                
                [self changeSong:arc4random()%(self.collectionArray.count )];
                
            }
            else if (self.playStyle == 2){
                
                [self changeSong:[self songPlace]];
                
            }
            }

        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            
            if (self.collectionArray.count != 0) {
                
            if (self.playStyle == 0) {
                NSInteger temp = [self songPlace] ;
                
                if (temp  == 0) {
                    temp = self.collectionArray.count - 1;
                }else{
                    temp -= 1;
                }
                [self changeSong:temp];
            }
            else if (self.playStyle == 1){
                
                [self changeSong:arc4random()%(self.collectionArray.count )];
            }
            else if (self.playStyle == 2){
                
                [self changeSong:[self songPlace]];
                
           }
         }
      }
   }
}


- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

#pragma mark 收藏按钮
-(void)clickCollection:(UIButton *)sender{
    
    MusicDatabase *musicDatabase = [MusicDatabase musicDatabase];

    if (self.collection == NO) {
        [sender setImage:[UIImage imageNamed:@"iconfont-xin-2"] forState:UIControlStateNormal];
        [musicDatabase insertMusic:self.databaseDic];
        [self.collectionArray addObject:self.databaseDic];
        self.databaseDic = self.collectionArray.lastObject;
        self.collection = YES;
    }
    else{
        [sender setImage:[UIImage imageNamed:@"iconfont-xin"] forState:UIControlStateNormal];

        if (self.collectionArray.count != 1) {
            [musicDatabase deleteMusic:self.databaseDic];
            [self.collectionArray removeObject:self.databaseDic];
            self.databaseDic = self.collectionArray.lastObject;
            [self changeSong:self.collectionArray.count - 1];
            self.collection = YES;
        }else{
            
            [musicDatabase deleteMusic:self.databaseDic];
            [self.collectionArray removeObject:self.databaseDic];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
                if (self.isPlaying == NO) {
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }];
            [alert addAction:cancel];
         
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        }
        
    }
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.collectionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentify = @"collection";
    
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[[CollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.songName.text = [self.collectionArray[indexPath.row] objectForKey:@"SN"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30 * KH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self changeSong:indexPath.row];
    self.databaseDic = self.collectionArray[indexPath.row];
    self.scrollView.contentOffset = CGPointMake(Kwidth, 0);
    CATransition *transaction = [CATransition animation];
    [transaction setDuration:0.5];
    transaction.type = @"cube";
    transaction.subtype = @"kCATransitionFromRight";
    [self.scrollView.layer addAnimation:transaction forKey:@"qwe"];
    
}
#pragma mark 改变歌曲
-(void)changeSong:(NSInteger)number{
    
    NSURL *playURL = [NSURL URLWithString:[self.collectionArray[number] objectForKey:@"musicUrl"]];
    AVAsset *musicAsset = [AVURLAsset URLAssetWithURL:playURL options:nil];
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:musicAsset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:playItem];
    
    self.title = [self.collectionArray[number] objectForKey:@"SN"];
    
    if ([[self.collectionArray[number] objectForKey:@"SW"]isEqualToString:@"暂无歌词"]) {
        
        self.word.text = @"暂无歌词";
        self.word.font = [UIFont systemFontOfSize:18 * KW];
        self.word.textColor = [UIColor whiteColor];
        
        [[self.view viewWithTag:100] addSubview:self.word];
        
        self.word.frame = CGRectMake(150 * KW, 240 * KH, Kwidth - 80 * 2 * KW, 50 * KH);
        
    }else{
        //自适应歌词高度
        CGSize size = CGSizeMake(Kwidth - 80 * 2 * KW, MAXFLOAT);
        
        NSDictionary *style = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:18 * KW],NSFontAttributeName, nil];
        
        self.result = [[self.collectionArray[number] objectForKey:@"SW"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
        
        
        self.word.frame = CGRectMake(0 , 0, Kwidth - 80 * 2 * KW, self.result.size.height);
        
        self.wordView.contentSize = CGSizeMake(Kwidth - 80 * 2 * KW, self.result.size.height);
        
        self.word.text = [self.collectionArray[number] objectForKey:@"SW"];
        self.word.font = [UIFont systemFontOfSize:18 * KW];
        self.word.textColor = [UIColor whiteColor];
        self.word.numberOfLines = -1;
        [self.wordView addSubview:self.word];
        [[self.view viewWithTag:100] addSubview:self.wordView];
        
        self.wordView.frame = CGRectMake(95 * KW, 80 * KH, Kwidth - 80 * 2 * KW, 400 * KH);
        
    }
    
    self.userName.text = [NSString stringWithFormat:@"BY: %@",[self.collectionArray[number] objectForKey:@"userName"]];
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[self.collectionArray[number] objectForKey:@"picture"]]placeholderImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    
    [self.playButton setImage:[[UIImage imageNamed:@"iconfont-tingzhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.isPlaying = YES;
    [self.avPlayer play];
    
    self.collection = YES;
    [self.collecButton setImage:[UIImage imageNamed:@"iconfont-xin-2"] forState:UIControlStateNormal];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 0) {
        
        [self.songTableView reloadData];
    }
    self.pageControl.currentPage = scrollView.contentOffset.x / Kwidth ;

}

#pragma mark 单例
+(PlayingViewController *)defaultPlayingViewController{
    
    static PlayingViewController *playingViewController = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        playingViewController = [[PlayingViewController alloc]init];
        
    });
    
    return playingViewController;
}

-(void)clickShare:(UIButton *)sender{
    
    [self.view bringSubviewToFront:self.shairView];
    self.shairView.hidden = NO;
}



-(void)clickWeichat:(UIButton *)sender{
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [NSString stringWithFormat:@"%@  %@",self.SN,self.musicUrl];
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    self.shairView.hidden = YES;
}

-(void)clickWeibo:(UIButton *)sender{
    
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
    
    self.shairView.hidden = YES;
    
}
-(void)cancelView:(UIButton *)sender{
    
    self.shairView.hidden = YES;
}

-(void)tapShairView:(UITapGestureRecognizer *)tap{
    
    self.shairView.hidden = YES;
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
