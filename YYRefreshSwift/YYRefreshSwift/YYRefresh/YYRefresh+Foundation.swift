//
//  YYRefreshFoundation.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

// MARK: - Protocol

///自定义RefreshView必须实现的协议
public protocol YYRefreshView: class {
	var view: UIView { get }
	/// 不同状态时的显示
	func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool)
}

///为协议扩展一个默认的实现来实现类似Objc里面的可选协议
extension YYRefreshView {
	public func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool) { }
}

///Do UIView<SomeProtocol> in Swift
extension YYRefreshView where Self: UIView {
	public var view: UIView {
		return self
	}
}

// MARK: - Type
public extension YYRefresh {
	/** 刷新控件的位置 */
    enum Position {
		case top, left, bottom, right
	}
	
	/** 刷新控件的状态 */
    enum State {
		case idle       /** 普通闲置状态 */
		case ready      /** 松开就可以进行刷新的状态 */
		case refreshing /** 正在刷新中的状态 */
		case noMore     /** 所有数据加载完毕，没有更多的数据了 */
	}
	
	/** 刷新控件的配置 */
    struct Config {
		public var textIdle = "下拉可以刷新"
		public var textReady = "松开立即刷新"
		public var textRefreshing = "正在刷新..."
		public var textNoMore = "没有更多数据了..."
		
		public var viewHeight: CGFloat = 50.0
		public var readyOffset: CGFloat = 50.0
		
		public var animationDurationFast = 0.25
		public var animationDurationSlow = 0.4
		public var parkVisible = true
		
		public init() {
			
		}
	}
}


// MARK: - Function
extension YYRefresh {
	static func radiansToDegress(_ radians: Double) -> CGFloat {
		return CGFloat(((radians / .pi) * 180.0))
	}
	
	static func degreesToRadians(_ degrees: Double) -> CGFloat {
		return CGFloat(((degrees * .pi) / 180.0))
	}
	
	static func imageFromBundle(named: String) -> UIImage? {
		let fullName = "YYRefresh.bundle/images/" + named
		let frameworkFullName = "Frameworks/YYSDK.framework/YYRefresh.bundle/images/" + named
		return UIImage(named: fullName) ?? UIImage(named: frameworkFullName)
	}
}
