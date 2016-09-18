//
//  YYRefreshFoundation.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

// MARK: - Type

/** 刷新控件的位置 */
public enum YYRefreshPosition {
    case top, left, bottom, right
}

/** 刷新控件的状态 */
public enum YYRefreshState {
    case idle       /** 普通闲置状态 */
    case ready      /** 松开就可以进行刷新的状态 */
    case refreshing /** 正在刷新中的状态 */
}

/** 刷新控件的配置 */
public struct YYRefreshConfig {
    public var textIdle = "下拉可以刷新"
    public var textReady = "松开立即刷新"
    public var textRefreshing = "正在刷新..."
    
    public var viewHeight: CGFloat = 50.0
    public var readyOffset: CGFloat = 50.0
    
    public var animationDurationFast = 0.25
    public var animationDurationSlow = 0.4
    public var parkVisible = true
    
    public init() {
        
    }
}

// MARK: - Protocol

//自定义RefreshView必须实现的协议
public protocol YYRefreshViewProtocol {
    var view: UIView { get }
    //不同状态时的显示
    func show(_ state: YYRefreshState, config: YYRefreshConfig, animated: Bool)
}

//为协议扩展一个默认的实现来实现类似Objc里面的可选协议
extension YYRefreshViewProtocol {
    public func show(_ state: YYRefreshState, config: YYRefreshConfig, animated: Bool) { }
}

//Do UIView<SomeProtocol> in Swift
extension YYRefreshViewProtocol where Self: UIView {
    public var view: UIView {
        return self
    }
}

extension UIView {
    //设置view的anchorPoint，同时保证view的frame不改变
    public func setAnchorPoint(_ anchorPoint: CGPoint) {
        let oldOrigin = frame.origin
        layer.anchorPoint = anchorPoint
        let newOrign = frame.origin
        let transition = CGPoint(x: newOrign.x - oldOrigin.x, y: newOrign.y - oldOrigin.y)
        center = CGPoint(x: center.x - transition.x, y: center.y - transition.y)
    }
}


// MARK: - Function
func radiansToDegress(_ radians: Double) -> CGFloat {
    return CGFloat(((radians / M_PI) * 180.0))
}
func degreesToRadians(_ degrees: Double) -> CGFloat {
    return CGFloat(((degrees * M_PI) / 180.0))
}

func imageFromBundle(named: String) -> UIImage? {
    let fullName = "YYRefresh.bundle/images/" + named
    let frameworkFullName = "Frameworks/YYSDK.framework/YYRefresh.bundle/images/" + named
    return UIImage(named: fullName) ?? UIImage(named: frameworkFullName)
}

