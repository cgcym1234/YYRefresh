//
//  YYRefreshView.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"
#import "YYRefreshConst.h"

@interface YYRefreshView : UIView<YYRefreshView>

@property (nonatomic, assign) YYRefreshPosition postion;

- (instancetype)initWithPostion:(YYRefreshPosition)postion;
- (void)showWithState:(YYRefreshState)state config:(YYRefreshConfig *)config animated:(BOOL)animated;

@end
