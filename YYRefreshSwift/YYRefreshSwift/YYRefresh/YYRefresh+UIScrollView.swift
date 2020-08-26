//
//  YYRefresh+UIScrollView.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/9/25.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit

public extension UIScrollView {
    @discardableResult
    func addYYRefresh(position: YYRefresh.Position,
                      config: YYRefresh.Config? = nil,
                      refreshView: YYRefreshView? = nil,
                      action: ((YYRefresh) -> Void)?) -> YYRefresh {
        let refresh = YYRefresh(position: position,
                                config: config,
                                refreshView: refreshView,
                                action: action)
        switch position {
        case .top:
            yy_topRefresh = refresh
        case .left:
            yy_leftRefresh = refresh
        case .bottom:
            yy_bottomRefresh = refresh
        case .right:
            yy_rightRefresh = refresh
        }
        addSubview(refresh)
        return refresh
    }

    var yy_topRefresh: YYRefresh? {
        get {
            objc_getAssociatedObject(self, &Keys.topRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &Keys.topRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var yy_leftRefresh: YYRefresh? {
        get {
            objc_getAssociatedObject(self, &Keys.leftRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &Keys.leftRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var yy_bottomRefresh: YYRefresh? {
        get {
            objc_getAssociatedObject(self, &Keys.bottomRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &Keys.bottomRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var yy_rightRefresh: YYRefresh? {
        get {
            objc_getAssociatedObject(self, &Keys.rightRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &Keys.rightRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private struct Keys {
        static var topRefreash: UInt8 = 0
        static var leftRefreash: UInt8 = 0
        static var bottomRefreash: UInt8 = 0
        static var rightRefreash: UInt8 = 0
    }
}
