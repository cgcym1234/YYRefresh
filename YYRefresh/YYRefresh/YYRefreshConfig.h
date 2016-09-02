//
//  YYRefreshConfig.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//可以根据需要自行拓展
@interface YYRefreshConfig : NSObject

@property (nonatomic, strong) NSString *textIdle;//default "下拉可以刷新"
@property (nonatomic, strong) NSString *textReady;//"default 松开立即刷新"
@property (nonatomic, strong) NSString *textRefreshing;//default "正在刷新..."

@property (nonatomic, assign) CGFloat viewHeight;   //default 50.0
@property (nonatomic, assign) CGFloat readyOffset;  //default 50.0

@property (nonatomic, assign) CGFloat animationDurationFast;//default 0.25
@property (nonatomic, assign) CGFloat animationDurationSlow;//default  0.4

+ (instancetype)defaultConfig;

@end
