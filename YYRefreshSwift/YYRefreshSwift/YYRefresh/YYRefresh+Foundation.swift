//
//  YYRefreshFoundation.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

// MARK: - Protocol

/// 自定义RefreshView必须实现的协议
public protocol YYRefreshView: class {
    var view: UIView { get }
    /// 不同状态时的显示
    func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool)
}

/// 为协议扩展一个默认的实现来实现类似Objc里面的可选协议
public extension YYRefreshView {
    func show(_: YYRefresh.State, config _: YYRefresh.Config, animated _: Bool) {}
}

public extension YYRefreshView where Self: UIView {
    var view: UIView { self }
}

// MARK: - Type

public extension YYRefresh {
    /** 刷新控件的位置 */
    enum Position {
        case top, left, bottom, right
    }

    /** 刷新控件的状态 */
    enum State {
        case idle /** 普通闲置状态 */
        case ready /** 松开就可以进行刷新的状态 */
        case refreshing /** 正在刷新中的状态 */
        case noMore /** 所有数据加载完毕，没有更多的数据了 */
    }

    /** 刷新控件的配置 */
    struct Config {
        public var textIdle = ""
        public var textReady = ""
        public var textRefreshing = ""
        public var textNoMore = ""

        public var viewHeight: CGFloat = 50.0
        public var readyOffset: CGFloat = 50.0

        public var animationDurationFast = 0.25
        public var animationDurationSlow = 0.4
        public var parkVisible = true
        public var visableCheckAutomatic = false

        public init() {}

        public static let `default`: Config = {
            var config = Config()
            config.textIdle = "下拉可以刷新"
            config.textReady = "松开立即刷新"
            config.textRefreshing = "正在刷新..."
            config.textNoMore = "没有更多数据了..."
            return config
        }()
    }
}

// MARK: - Function

extension YYRefresh {
    static func radiansToDegress(_ radians: Double) -> CGFloat {
        CGFloat((radians / .pi) * 180.0)
    }

    static func degreesToRadians(_ degrees: Double) -> CGFloat {
        CGFloat((degrees * .pi) / 180.0)
    }

    static func imageFromBundle(named: String) -> UIImage? {
        let fullName = "YYRefresh.bundle/images/" + named
        let frameworkFullName = "Frameworks/YYCore.framework/YYRefresh.bundle/images/" + named
        return UIImage(named: fullName) ?? UIImage(named: frameworkFullName)
    }
}
