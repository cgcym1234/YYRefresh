//
//  UIScrollView+YYRefresh.m
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIScrollView+YYRefresh.h"
#import <objc/runtime.h>

static char kTopRefreash;
static char kLeftRefreash;
static char kBottomRefreash;
static char kRightRefreash;

@implementation UIScrollView (YYRefresh)

- (YYRefresh *)yy_topRefresh {
    return objc_getAssociatedObject(self, &kTopRefreash);
}
- (void)setYy_topRefresh:(YYRefresh *)yy_topRefresh {
    objc_setAssociatedObject(self, &kTopRefreash, yy_topRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYRefresh *)yy_leftRefresh {
    return objc_getAssociatedObject(self, &kLeftRefreash);
}
- (void)setYy_leftRefresh:(YYRefresh *)yy_leftRefresh {
    objc_setAssociatedObject(self, &kLeftRefreash, yy_leftRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYRefresh *)yy_bottomRefresh {
    return objc_getAssociatedObject(self, &kBottomRefreash);
}
- (void)setYy_bottomRefresh:(YYRefresh *)yy_bottomRefresh {
    objc_setAssociatedObject(self, &kBottomRefreash, yy_bottomRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYRefresh *)yy_rightRefresh {
    return objc_getAssociatedObject(self, &kRightRefreash);
}
- (void)setYy_rightRefresh:(YYRefresh *)yy_rightRefresh {
    objc_setAssociatedObject(self, &kRightRefreash, yy_rightRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler {
    return [self addYYRefreshAtPosition:position config:nil action:actionHandler ];
}

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position config:(YYRefreshConfig *)config action:(void (^)(YYRefresh *refresh))actionHandler {
    return [self addYYRefreshAtPosition:position config:config customView:nil action:actionHandler];
}

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position config:(YYRefreshConfig *)config customView:(UIView<YYRefreshView> *)refreshView action:(void (^)(YYRefresh *refresh))actionHandler {
    YYRefresh *refresh = [[YYRefresh alloc] initWithScrollView:self position:position action:actionHandler config:config customView:refreshView];
    [self addSubview:refresh];
    switch (position) {
        case YYRefreshPositionTop: {
            self.yy_topRefresh = refresh;
            break;
        }
        case YYRefreshPositionLeft: {
            self.yy_leftRefresh= refresh;
            break;
        }
        case YYRefreshPositionBottom: {
            self.yy_bottomRefresh = refresh;
            break;
        }
        case YYRefreshPositionRight: {
            self.yy_rightRefresh= refresh;
            break;
        }
    }
    return refresh;
}

@end
