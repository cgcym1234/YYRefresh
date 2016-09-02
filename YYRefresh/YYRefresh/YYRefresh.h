//
//  YYRefresh.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"
#import "YYRefreshConst.h"

@interface YYRefresh : UIView

@property (nonatomic, assign, readonly) YYRefreshPosition position;
@property (nonatomic, assign, readonly) YYRefreshState state;
@property (nonatomic, strong) YYRefreshConfig *config;

- (void)beginRefresh;
- (void)endRefresh;

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler;

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config;

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config customView:(UIView<YYRefreshView> *)refreshView;

@end

























