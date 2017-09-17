//
//  PlayingViewController.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PlayingMusic)(BOOL playingMusic);

@interface PlayingViewController : BaseViewController
//接收歌曲地址
@property(nonatomic,copy)NSString *musicUrl;
//接收用户信息
@property(nonatomic,retain)NSDictionary *user;
//接收歌词
@property(nonatomic,copy)NSString *SW;
//歌名
@property(nonatomic,copy)NSString *SN;

@property(nonatomic,copy)PlayingMusic playingMusic;

+(PlayingViewController *)defaultPlayingViewController;
    

    
    



@end
//@property(nonatomic,retain)NSDictionary *user;  //用户信息
//
//@property(nonatomic,retain)NSString *FN;  //歌曲地址
//
//@property(nonatomic,retain)NSString *SW;  //歌词