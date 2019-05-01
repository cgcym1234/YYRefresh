//
//  YYRefresh+UIScrollView.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/9/25.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit


public extension UIScrollView {
	///
	@discardableResult
    func addYYRefresh(position: YYRefresh.Position, config: YYRefresh.Config? = nil, refreshView: YYRefreshView? = nil, action: ((YYRefresh) -> Void)?) -> YYRefresh {
		let refresh = YYRefresh(position: position, config: config, refreshView: refreshView, action: action)
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
			return objc_getAssociatedObject(self, &UIScrollView.topRefreash) as? YYRefresh
		}
		set {
			objc_setAssociatedObject(self, &UIScrollView.topRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
    
    var yy_leftRefresh: YYRefresh? {
		get {
			return objc_getAssociatedObject(self, &UIScrollView.leftRefreash) as? YYRefresh
		}
		set {
			objc_setAssociatedObject(self, &UIScrollView.leftRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
    
    var yy_bottomRefresh: YYRefresh? {
		get {
			return objc_getAssociatedObject(self, &UIScrollView.bottomRefreash) as? YYRefresh
		}
		set {
			objc_setAssociatedObject(self, &UIScrollView.bottomRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
    
    var yy_rightRefresh: YYRefresh? {
		get {
			return objc_getAssociatedObject(self, &UIScrollView.rightRefreash) as? YYRefresh
		}
		set {
			objc_setAssociatedObject(self, &UIScrollView.rightRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	private static var topRefreash: UInt8 = 0
	private static var leftRefreash: UInt8 = 0
	private static var bottomRefreash: UInt8 = 0
	private static var rightRefreash: UInt8 = 0
}
