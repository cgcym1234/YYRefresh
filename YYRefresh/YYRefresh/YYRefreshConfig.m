//
//  YYRefreshConfig.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYRefreshConfig.h"
#import "YYRefreshConst.h"

@implementation YYRefreshConfig

+ (instancetype)defaultConfig {
    YYRefreshConfig *config = [YYRefreshConfig new];
    config.textIdle = YYRefreshIdleText;
    config.textReady = YYRefreshReadyText;
    config.textRefreshing = YYRefreshRefreshingText;
    
    config.viewHeight = YYRefreshViewHeight;
    config.readyOffset = YYRefreshReadyOffset;
    config.animationDurationFast = YYRefreshAnimationDurationFast;
    config.animationDurationSlow = YYRefreshAnimationDurationSlow;
    config.parkVisible = YES;
    return config;
}


@end
