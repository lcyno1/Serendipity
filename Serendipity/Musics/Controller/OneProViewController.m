//
//  OneProViewController.m
//  Serendipity
//
//  Created by 李重阳 on 15/12/25.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "OneProViewController.h"

@interface OneProViewController ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@end

@implementation OneProViewController

-(void)dealloc{
    
    [_webView release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.tabBar.hidden = YES;
    
    //选择自己喜欢的颜色
    UIColor * color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    self.title = self.nameTitle;
    
 
    //返回按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = button;

    
   self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    self.webView.opaque = NO; //不透明
    
    self.webView.scalesPageToFit = NO; //禁止用户缩放
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    [_webView release];

}


-(void)cancel:(UIBarButtonItem *)sender{
    
    self.tabBarController.tabBar.hidden = NO;
    
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
