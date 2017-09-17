//
//  StyleViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "StyleViewController.h"
#import "MusicViewController.h"

#define Kwidth self.view.frame.size.width //屏幕宽

#define Kheight self.view.frame.size.height  //屏幕高


@interface StyleViewController ()
//存储5个分类
@property(nonatomic,retain)NSArray *styleArray;

@property(nonatomic,retain)UICollectionView *collectionView;

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,assign)BOOL residue;

@end

@implementation StyleViewController

-(void)dealloc{
    
    [_styleArray release];
    [_collectionView release];
    [_scrollView release];
    [super dealloc];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    self.styleArray = [NSArray array];
    
    NSArray *styleArray = @[@"流行",@"爵士",@"小清新",@"轻音乐",@"中国风",@"摇滚",@"DJ",@"古风",@"武侠",@"钢琴曲",@"广场舞",@"民谣",@"乡村"];
    
    NSArray *scene = @[@"感动",@"寂寞",@"安静",@"温暖",@"浪漫",@"治愈",@"伤感",@"想念",@"激情",@"喜悦",@"失恋",@"怀念"];
    
    NSArray *place = @[@"夜晚",@"咖啡厅",@"夜店",@"旅游",@"车载",@"阅读",@"一个人",@"KTV"];
    
    NSArray *language = @[@"国语",@"英文",@"韩文",@"日文",@"粤语",@"德语",@"西班牙语",@"闽南语",@"法语"];
    
    NSArray *other = @[@"原创",@"翻唱",@"毕业",@"情歌",@"经典",@"怀旧",@"爱情",@"励志",@"儿歌",@"影视",@"男女对唱",@"歌词控",@"动漫"];
    //风格 情景 场景 语种 其他
    
    self.styleArray = @[styleArray,scene,place,language,other];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    UIButton *recommend = [UIButton buttonWithType:UIButtonTypeCustom];
    recommend.frame = CGRectMake(10 * KW, 20 * KH, Kwidth - 10 * 2 * KW, 40 * KH);
    recommend.layer.borderColor = [UIColor greenColor].CGColor;
    recommend.layer.borderWidth = 0.7;
    [recommend setTitle:@"推荐" forState:UIControlStateNormal];
    [recommend addTarget:self action:@selector(buttonStyle:) forControlEvents:UIControlEventTouchUpInside];
    [recommend setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:recommend];
    

    [self setButton:60 * KH buttonNumber:styleArray.count style:@"推荐" nameArray: styleArray];
    
    [self setButton:220 * KH buttonNumber:scene.count style:@"情景" nameArray:scene];
    
    [self setButton:360 * KH buttonNumber:place.count style:@"场景" nameArray:place];

    [self setButton:470 * KH buttonNumber:language.count style:@"语种" nameArray:language];
    
    [self setButton:610 * KH buttonNumber:other.count style:@"其他" nameArray:other];
    
    self.scrollView.contentSize = CGSizeMake(Kwidth, 820 * KH);
    [self.view addSubview:self.scrollView];
    [_scrollView release];
}

-(void)setButton:(NSInteger)Y buttonNumber:(NSInteger)buttonNumber style:(NSString *)style nameArray:(NSArray *)nameArray{
    
    UILabel *styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 * KW, Y * KH, 200 * KW, 40 * KH)];
    styleLabel.text = style;
    styleLabel.font = [UIFont systemFontOfSize:15 * KW];
    styleLabel.textColor = [UIColor lightGrayColor];
    styleLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:styleLabel];
    [styleLabel release];
    
    
    NSInteger temp = buttonNumber / 4;
    
    if (buttonNumber % 4 != 0) {
        self.residue = YES;
    }
    
    
    for (int i = 0; i < temp; i++) {
        for (int j = 0; j < 4; j++) {
            //88.75
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 * KW + j * 88.85 * KW, Y + 35 * KH + 31 * i, 80 * KW, 27 * KH);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:nameArray[i * 4 + j] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonStyle:) forControlEvents:UIControlEventTouchUpInside];
            //button.backgroundColor = [UIColor whiteColor];
            button.layer.borderWidth = 0.4;
            button.layer.borderColor = [UIColor blackColor].CGColor;
            [self.scrollView addSubview:button];
            
        }
        
    }
    if (self.residue == YES) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 * KW, Y + 35 * KH + 31 * temp , 80 * KW , 27 * KH);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:nameArray[temp * 4 ] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonStyle:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.3;
        [self.scrollView addSubview:button];
    }
    
    self.residue = NO;
}

-(void)buttonStyle:(UIButton *)sender{
    
    [self.delegate changeStyle:sender.titleLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
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
