//
//  LCYNewWorking.h
//  TableView&CollectionView
//
//  Created by 李重阳 on 15/12/21.
//  Copyright © 2015年 李日红. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface LCYNewWorking : NSObject


+(void)GetDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void(^)(id responseObject))response failed:(void(^)(NSError *error))err;

+(void)PostDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void(^)(id responseObject))response failed:(void(^)(NSError *error))err;


@end
