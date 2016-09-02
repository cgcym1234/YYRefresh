//
//  YYRefresh.m
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYRefresh.h"

#import "YYRefreshView.h"

@interface YYRefresh ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<YYRefreshView> *refreshView;

/** 记录scrollView刚开始的inset */
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, assign) YYRefreshPosition position;
@property (nonatomic, assign) YYRefreshState state;
@property (nonatomic, copy) void (^actionHandler)(YYRefresh *refresh);

@end

@implementation YYRefresh

#pragma mark - Initialization

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *))actionHandler {
    return [self initWithScrollView:scroll position:position action:actionHandler config:nil];
}

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config {
    return [self initWithScrollView:scroll position:position action:actionHandler config:nil customView:nil];
}

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config customView:(UIView<YYRefreshView> *)refreshView {
    if (self = [super init]) {
        _position = position;
        _actionHandler = actionHandler;
        _config = config ?: [YYRefreshConfig defaultConfig];
        _refreshView = refreshView ?: [[YYRefreshView alloc] initWithPostion:_position];
        _state = YYRefreshStateIdle;
        [self setContext];
    }
    return self;
}

- (void)setContext {
    [self addSubview:_refreshView];
    [_refreshView showWithState:YYRefreshStateIdle config:_config animated:NO];
//    self.backgroundColor = [UIColor orangeColor];
}

#pragma mark - Override

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        switch (_position) {
            case YYRefreshPositionTop:
            case YYRefreshPositionBottom:
                _scrollView.alwaysBounceVertical = YES;
                break;
            case YYRefreshPositionLeft:
            case YYRefreshPositionRight: {
                _scrollView.alwaysBounceHorizontal = YES;
                break;
            }
        }
        
        // 添加监听
        [self addObservers];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLocation];
}

#pragma mark - Location

- (void)updateLocation {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = CGRectGetWidth(_scrollView.bounds);
    switch (_position) {
        case YYRefreshPositionTop: {
            y = -YYRefreshViewHeight;
            break;
        }
        case YYRefreshPositionLeft: {
            x = -YYRefreshViewHeight + YYRefreshViewHeight;
            width = CGRectGetHeight(_scrollView.bounds);
            break;
        }
        case YYRefreshPositionBottom: {
            y = MAX(_scrollView.contentSize.height, CGRectGetHeight(_scrollView.bounds));
            break;
        }
        case YYRefreshPositionRight: {
            /**
             在左右方向加刷新控件时，采用的方式是，将refreshView顺时针旋转90度，
             旋转选择的是左上角那个点，所以这里x的要额外加refreshView的高度
             */
            x = MAX(_scrollView.contentSize.width, CGRectGetWidth(_scrollView.bounds)) + YYRefreshViewHeight;
            width = CGRectGetHeight(_scrollView.bounds);
            break;
        }
    }
    CGRect frame = CGRectMake(x, y, width, YYRefreshViewHeight);
    self.transform = CGAffineTransformIdentity;
    self.frame = frame;
    _refreshView.frame = self.bounds;
    
    if (_position == YYRefreshPositionLeft || _position == YYRefreshPositionRight) {
        //如果直接设置anchorPoint，view的frame会改变
        [self setAnchorPoint:CGPointMake(0, 0) forView:self];
        self.transform = CGAffineTransformRotate(self.transform, DegreesToRadians(90.1));
    }
}

- (void)updatePositionWhenContentsSizeIsChanged:(NSDictionary *)change {
    CGSize oldContentSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
    CGSize newContentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
    CGPoint center = self.center;
    
    /**
     这里做了点限制，防止refreshView 因为newContentSize太小，而显示到可见区域
     */
    if (self.position == YYRefreshPositionBottom) {
        newContentSize.height = MAX(_scrollView.contentSize.height, CGRectGetHeight(_scrollView.bounds));
        center.y += newContentSize.height - oldContentSize.height;
    }
    else if (self.position == YYRefreshPositionRight) {
        newContentSize.width = MAX(_scrollView.contentSize.width, CGRectGetWidth(_scrollView.bounds));
        center.x += newContentSize.width - oldContentSize.width;
    }
    self.center = center;
}

//设置view的anchorPoint，同时保证view的frame不改变
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark - KVO

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
    [self.scrollView addObserver:self forKeyPath:YYRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:YYRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:YYRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:YYRefreshKeyPathContentSize];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:YYRefreshKeyPathContentSize]) {
        [self updatePositionWhenContentsSizeIsChanged: change];
        return;
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:YYRefreshKeyPathContentOffset]) {
        [self scrollViewDidScroll:_scrollView];
    }
}

#pragma mark - Public

- (void)beginRefresh {
    if (_state != YYRefreshStateRefreshing) {
        self.state = YYRefreshStateRefreshing;
        [UIView animateWithDuration:_config.animationDurationFast animations:^{
            [self parkVisible:YES];
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)endRefresh {
    if (_state == YYRefreshStateRefreshing) {
        [UIView animateWithDuration:_config.animationDurationFast animations:^{
            [self parkVisible:NO];
        } completion:^(BOOL finished) {
            self.state = YYRefreshStateIdle;
        }];
    }
}

#pragma mark - Private

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 正在刷新的refreshing状态
    if (_state == YYRefreshStateRefreshing) {
        return;
    }
    
    //    NSLog(@"%@  %@", scrollView, self);
    if (scrollView.isDragging) {
        if (_state == YYRefreshStateIdle && [self isScrolledOverReadyOffset]) {
            // 转为即将刷新状态
            self.state = YYRefreshStateReady;
        } else if (_state == YYRefreshStateReady && ![self isScrolledOverReadyOffset]) {
            // 转为普通状态
            self.state = YYRefreshStateIdle;
        }
    } else {
        // 即将刷新 && 手松开
        if (_state == YYRefreshStateReady) {
            // 开始刷新
            [self beginRefresh];
        }
    }
}

- (void)executeRefreshingCallback {
    if (_actionHandler) {
        _actionHandler(self);
    }
}

- (void)parkVisible:(BOOL)visible {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    // 增加滚动区域
    CGFloat contentOffset = visible ? YYRefreshViewHeight : -YYRefreshViewHeight;
    switch (_position) {
        case YYRefreshPositionTop:
            contentInset.top += contentOffset;
            break;
        case YYRefreshPositionBottom:
            contentInset.bottom += contentOffset;
            break;
        case YYRefreshPositionLeft:
            contentInset.left += contentOffset;
            break;
        case YYRefreshPositionRight:
            contentInset.right += contentOffset;
            break;
    }
    // 设置滚动位置
    self.scrollView.contentInset = contentInset;
}

- (BOOL)isScrolledOverReadyOffset {
    CGFloat readyOffset = _config.readyOffset;
    switch (self.position) {
        case YYRefreshPositionTop:
            return self.scrollView.contentOffset.y <= -readyOffset;
        case YYRefreshPositionBottom:
            if (self.scrollView.contentSize.height > self.scrollView.frame.size.height)
                return self.scrollView.contentOffset.y >= (self.scrollView.contentSize.height - self.scrollView.frame.size.height) + readyOffset;
            else
                return self.scrollView.contentOffset.y >= readyOffset;
        case YYRefreshPositionLeft:
            return self.scrollView.contentOffset.x <= -readyOffset;
        case YYRefreshPositionRight:
            return self.scrollView.contentOffset.x >= (self.scrollView.contentSize.width - self.scrollView.frame.size.width) + readyOffset;
    }
    
    return NO;
}

#pragma mark - Setter

- (void)setState:(YYRefreshState)state {
    YYRefreshState oldState = _state;
    if (oldState == state) {
        return;
    }
    _state = state;
    [_refreshView showWithState:state config:_config animated:YES];
}

#pragma mark - Getter


@end











