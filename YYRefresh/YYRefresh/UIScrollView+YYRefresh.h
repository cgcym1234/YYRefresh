//
//  UIScrollView+YYRefresh.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefresh.h"

@interface UIScrollView (YYRefresh)

@property (nonatomic, strong) YYRefresh *yy_topRefresh;
@property (nonatomic, strong) YYRefresh *yy_leftRefresh;
@property (nonatomic, strong) YYRefresh *yy_bottomRefresh;
@property (nonatomic, strong) YYRefresh *yy_rightRefresh;

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler;

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config;

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config customView:(UIView<YYRefreshView> *)refreshView;

@end
