//
//  YYRefreshConst.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"


#define DegreesToRadians(degrees) ((degrees * M_PI) / 180.0)

typedef NS_ENUM(NSUInteger, YYRefreshPosition) {
    YYRefreshPositionTop = 1,
    YYRefreshPositionLeft,
    YYRefreshPositionBottom,
    YYRefreshPositionRight
};

/** 刷新控件的状态 */
typedef NS_ENUM(NSUInteger, YYRefreshState) {
    /** 普通闲置状态 */
    YYRefreshStateIdle,
    /** 松开就可以进行刷新的状态 */
    YYRefreshStateReady,
    /** 正在刷新中的状态 */
    YYRefreshStateRefreshing,
};


//自定义RefreshView必须实现的协议
@protocol YYRefreshView <NSObject>

@required
- (void)showWithState:(YYRefreshState)state config:(YYRefreshConfig *)config animated:(BOOL)animated;

@end

#pragma mark - [YYRefreshConfig defaultConfig] 默认值

UIKIT_EXTERN const CGFloat YYRefreshViewHeight;
UIKIT_EXTERN const CGFloat YYRefreshReadyOffset;
UIKIT_EXTERN const CGFloat YYRefreshAnimationDurationFast;
UIKIT_EXTERN const CGFloat YYRefreshAnimationDurationSlow;

UIKIT_EXTERN NSString *const YYRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const YYRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const YYRefreshKeyPathContentSize;

UIKIT_EXTERN NSString *const YYRefreshIdleText;
UIKIT_EXTERN NSString *const YYRefreshReadyText;
UIKIT_EXTERN NSString *const YYRefreshRefreshingText;

UIKIT_EXTERN NSString *const YYRefreshImageUp;
UIKIT_EXTERN NSString *const YYRefreshImageDown;



