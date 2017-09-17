//
//  StyleViewController.h
//  Serendipity
//
//  Created by 李重阳 on 15/12/28.
//  Copyright © 2015年 李重阳. All rights reserved.
//

#import "BaseViewController.h"
//#import <UIKit/UIKit.h>

@protocol StyleViewControllerDelegate <NSObject>

-(void)changeStyle:(NSString *)style;

@end


@interface StyleViewController : BaseViewController

@property(nonatomic,assign)id<StyleViewControllerDelegate>delegate;


@end
