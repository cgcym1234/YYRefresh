//
//  YYRefresh.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

/*
 beta 6 新增加了 open 关键字, 可以理解为之前的 public
 在同一个包 module 内, public 跟 open 的含义是一样的, 但是在 module 外, open 声明的成员变量和函数是可以被 override 的, 而 public 只是把接口公开出去, 而不能被 override
 */

var kTopRefreash: UInt8 = 0
var kLeftRefreash: UInt8 = 0
var kBottomRefreash: UInt8 = 0
var kRightRefreash: UInt8 = 0

// MARK: - Public

extension UIScrollView {
    
    public var yy_topRefresh: YYRefresh? {
        get {
            return objc_getAssociatedObject(self, &kTopRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &kTopRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var yy_leftRefresh: YYRefresh? {
        get {
            return objc_getAssociatedObject(self, &kLeftRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &kLeftRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var yy_bottomRefresh: YYRefresh? {
        get {
            return objc_getAssociatedObject(self, &kBottomRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &kBottomRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var yy_rightRefresh: YYRefresh? {
        get {
            return objc_getAssociatedObject(self, &kRightRefreash) as? YYRefresh
        }
        set {
            objc_setAssociatedObject(self, &kRightRefreash, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult public func addYYRefresh(position: YYRefreshPosition, config: YYRefreshConfig? = nil, refreshView: YYRefreshViewProtocol? = nil, action: ((YYRefresh) -> Void)?) -> YYRefresh {
        let refresh = YYRefresh(scrollView: self, position: position, config: config, refreshView: refreshView, action: action)
        addSubview(refresh)
        
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
        return refresh
    }
}


open class YYRefresh: UIView {
    
    // MARK: - Const
    let keyPathContentOffset = "contentOffset"
    let keyPathContentInset = "contentInset"
    let keyPathContentSize = "contentSize"
    
    // MARK: - Public Property
    open var position: YYRefreshPosition
    open var config: YYRefreshConfig
    open var state: YYRefreshState = .idle {
        willSet {
            refreshView.show(newValue, config: config, animated: true)
        }
    }
    
    // MARK: - Initialization
    public init(scrollView: UIScrollView, position: YYRefreshPosition, config: YYRefreshConfig? = nil, refreshView: YYRefreshViewProtocol? = nil, action: ((YYRefresh) -> Void)?) {
        self.position = position
        self.config = config ?? YYRefreshConfig()
        self.scrollView = scrollView
        self.refreshingCallback = action
        self.refreshView = refreshView ?? YYRefreshView(position: position)
        super.init(frame: CGRect.zero)
        setupContext()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    func setupContext() {
        addSubview(refreshView.view)
        //backgroundColor = UIColor.orange
        state = .idle
    }
    
    // MARK: - Public Method
    open func beginRefresh() {
        if state == .refreshing {
            return
        }
        self.state = .refreshing
        
        //显示悬停刷新状态
        if config.parkVisible {
            UIView.animate(withDuration: config.animationDurationFast, animations: {
                self.park(visible: true)
                }, completion: { (finished) in
                    self.refreshingCallback?(self)
            })
        } else {
            self.refreshingCallback?(self)
        }
        
    }
    
    open func endRefresh() {
        if state != .refreshing {
            return
        }
        if config.parkVisible {
            UIView.animate(withDuration: config.animationDurationFast, animations: {
                self.park(visible: false)
                }, completion: { (finished) in
                    self.state = .idle
            })
        } else {
            self.state = .idle
        }
        
    }
    
    // MARK: - Private Property
    weak var scrollView: UIScrollView!
    var refreshView: YYRefreshViewProtocol!
    var refreshingCallback: ((YYRefresh) -> Void)? = nil
    
    /** 记录scrollView刚开始的inset */
    //    var scrollViewOriginalInset: UIEdgeInsets
}

// MARK: - Override
extension YYRefresh {
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let newSuperview = newSuperview as? UIScrollView else {
            return
        }
        
        addObservers()
        scrollView = newSuperview
        
        switch position {
        case .top, .bottom:
            scrollView.alwaysBounceVertical = true
        case .left, .right:
            scrollView.alwaysBounceHorizontal = true
        }
    }
}

// MARK: - Private
extension YYRefresh {
    func layoutViews() {
        var x = CGFloat(0)
        var y = CGFloat(0)
        var viewWidth = min(scrollView.bounds.width, UIScreen.main.bounds.width)
        let viewHeight = config.viewHeight
        switch position {
        case .top:
            y -= viewHeight
        case .bottom:
            y = max(scrollView.contentSize.height, scrollView.bounds.height)
        case .left:
            /**
             在左右方向加刷新控件时，采用的方式是，将refreshView顺时针旋转90度，
             旋转选择的是左上角那个点，所以这里x的要额外加refreshView的高度
             */
            x = -viewHeight + viewHeight
            viewWidth = scrollView.bounds.height
        case .right:
            x = max(scrollView.contentSize.width, scrollView.bounds.width) + viewHeight
            viewWidth = scrollView.bounds.height
        }
        transform = CGAffineTransform.identity
        frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
        refreshView.view.frame = bounds
        
        if position == .left || position == .right {
            setAnchorPoint(CGPoint.zero)
            transform = self.transform.rotated(by: degreesToRadians(90))
        }
    }
    
    func updatePosition(change: [NSKeyValueChangeKey : Any]) {
        guard let oldContentSize = change[.oldKey] as? CGSize,
            var newContentSize = change[.newKey] as? CGSize else {
                return
        }
        var center = self.center
        /**
         这里做了点限制，防止refreshView 因为newContentSize太小，而显示到可见区域
         */
        if position == .bottom {
            newContentSize.height = max(scrollView.contentSize.height, scrollView.bounds.height)
            center.y += newContentSize.height - oldContentSize.height
        } else if position == .right {
            newContentSize.width = max(scrollView.contentSize.width, scrollView.bounds.width)
            center.y += newContentSize.width - oldContentSize.width
        }
        self.center = center
    }
    
    // 增加或减少滚动区域
    func park(visible: Bool) {
        guard let scrollView = scrollView else { return }
        var contentInset = scrollView.contentInset
        var contentOffset = scrollView.contentOffset
        let offset = visible ? config.viewHeight : -config.viewHeight
        switch position {
        case .top:
            contentInset.top += offset
            contentOffset.y = visible ? -config.readyOffset : 0
        case .bottom:
            contentInset.bottom += offset
        case .left:
            contentInset.left += offset
            contentOffset.x = visible ? -config.readyOffset : 0
        case .right:
            contentInset.right += offset
        }
        // 设置滚动位置
        scrollView.contentOffset = contentOffset
        
        // 增加滚动区域
        scrollView.contentInset = contentInset
    }
}

// MARK: - KVO
extension YYRefresh {
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.old, .new]
        scrollView.addObserver(self, forKeyPath: keyPathContentOffset, options: options, context: nil)
        scrollView.addObserver(self, forKeyPath: keyPathContentSize, options: options, context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: keyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: keyPathContentSize)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        
        // 这个就算看不见也需要处理
        if keyPath == keyPathContentSize {
            updatePosition(change: change!)
            return
        }
        
        // 看不见
        if isHidden { return }
        if keyPath == keyPathContentOffset {
            scrollViewDidScroll(scrollView)
        }
    }
}

// MARK: - UIScrollView
extension YYRefresh {
    var scrolledOverReadyOffset: Bool {
        let readyOffset = config.readyOffset
        var overReadyOffset = false
        switch position {
        case .top:
            overReadyOffset = scrollView.contentOffset.y <= -readyOffset
        case .left:
            overReadyOffset = scrollView.contentOffset.x <= -readyOffset
        case .bottom:
            if scrollView.contentSize.height > scrollView.frame.height {
                overReadyOffset = scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height + readyOffset
            } else {
                overReadyOffset = scrollView.contentOffset.y >= readyOffset
            }
            
        case .right:
            overReadyOffset = scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.width + readyOffset
        }
        return overReadyOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 正在刷新的refreshing状态
        if state == .refreshing {
            return
        }
        
        if scrollView.isDragging {
            if state == .idle && scrolledOverReadyOffset {
                state = .ready// 转为即将刷新状态
            } else if state == .ready && !scrolledOverReadyOffset {
                state = .idle// 转为普通状态
            }
        } else {
            // 即将刷新 && 手松开
            if state == .ready {
                beginRefresh()// 开始刷新
            }
        }
    }
}





















