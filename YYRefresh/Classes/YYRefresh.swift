//
//  YYRefresh.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class YYRefresh: UIView {
    // MARK: - Const

    let keyPathContentOffset = "contentOffset"
    let keyPathContentInset = "contentInset"
    let keyPathContentSize = "contentSize"

    // MARK: - Public Property

    public let position: YYRefresh.Position
    public var config: YYRefresh.Config {
        didSet {
            refreshView.show(state, config: config, animated: false)
        }
    }

    public private(set) var state: YYRefresh.State = .idle {
        willSet {
            refreshView.show(newValue, config: config, animated: true)
        }
    }

    // MARK: - Private Property

    private var scrollViewOriginalInset = UIEdgeInsets.zero
    private weak var scrollView: UIScrollView! {
        didSet {
            scrollViewOriginalInset = scrollView.contentInset

            switch position {
            case .top, .bottom:
                scrollView.alwaysBounceVertical = true
            case .left, .right:
                scrollView.alwaysBounceHorizontal = true
            }
        }
    }

    private let refreshView: YYRefreshView!
    private var refreshingCallback: ((YYRefresh) -> Void)?
    private var observers: [AnyObject] = []

    // MARK: - Initialization

    public init(position: YYRefresh.Position,
                config: YYRefresh.Config? = nil,
                refreshView: YYRefreshView? = nil,
                action: ((YYRefresh) -> Void)?) {
        self.position = position
        self.config = config ?? YYRefresh.Config()
        refreshingCallback = action
        self.refreshView = refreshView ?? YYRefresh.DefaultView(position: position)
        super.init(frame: CGRect.zero)
        setupContext()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObservers()
    }

    private func setupContext() {
        addSubview(refreshView.view)
        backgroundColor = .clear
        state = .idle

        observers.append(
            NotificationCenter.default.addObserver(
                forName: UIDevice.orientationDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.setNeedsLayout()
            }
        )
    }
}

// MARK: - Public Method

public extension YYRefresh {
    func setToIdleState() {
        state = .idle
    }

    func setToNoMoreState() {
        state = .noMore
    }

    func beginRefresh(notify: Bool = true) {
        if state == .refreshing {
            return
        }
        state = .refreshing

        /// 显示悬停刷新状态
        if config.parkVisible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.config.animateDurationParking, animations: {
                    self.parkVisible(true)
                }, completion: { _ in
                    if notify {
                        self.refreshingCallback?(self)
                    }
                })
            }
        } else {
            if notify {
                refreshingCallback?(self)
            }
        }
    }

    func endRefresh() {
        if state != .refreshing {
            return
        }
        state = .idle
        if config.parkVisible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.config.animateDurationParking, animations: {
                    self.parkVisible(false)
                }) { _ in
                    self.visableCheckAutomatic()
                }
            }
        }
    }

    func visableCheck() {
        if position == .bottom {
            isHidden = scrollView.contentSize.height < scrollView.bounds.height
        } else if position == .right {
            isHidden = scrollView.contentSize.width < scrollView.bounds.width
        }
    }

    func noMoreStateCheck() {
        if position == .bottom {
            state = scrollView.contentSize.height < scrollView.bounds.height ? .noMore : .idle
        } else if position == .right {
            state = scrollView.contentSize.width < scrollView.bounds.width ? .noMore : .idle
        }
    }
}

// MARK: - Override

extension YYRefresh {
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let newSuperview = newSuperview as? UIScrollView else {
            return
        }

        scrollView = newSuperview
        addObservers()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let superview = superview,
            superview.bounds.width != bounds.width else { return }
        layoutViews()
    }
}

// MARK: - KVO

extension YYRefresh {
    private func addObservers() {
        let options: NSKeyValueObservingOptions = [.old, .new]
        scrollView.addObserver(self, forKeyPath: keyPathContentOffset, options: options, context: nil)
        scrollView.addObserver(self, forKeyPath: keyPathContentSize, options: options, context: nil)
    }

    private func removeObservers() {
        superview?.removeObserver(self, forKeyPath: keyPathContentOffset)
        superview?.removeObserver(self, forKeyPath: keyPathContentSize)
    }

    public override func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
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

    private func updatePosition(change: [NSKeyValueChangeKey: Any]) {
        guard let oldContentSize = change[.oldKey] as? CGSize,
            var newContentSize = change[.newKey] as? CGSize else {
            return
        }
        var center = self.center

        if position == .bottom {
            newContentSize.height = scrollView.contentSize.height
            center.y += newContentSize.height - oldContentSize.height
        } else if position == .right {
            /// 这里做了点限制，防止refreshView 因为newContentSize太小，而显示到可见区域
            newContentSize.width = max(scrollView.contentSize.width, scrollView.bounds.width)
            center.y += newContentSize.width - oldContentSize.width
        }
        self.center = center
        visableCheckAutomatic()
    }

    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 正在刷新的refreshing状态
        if state == .refreshing || state == .noMore {
            return
        }

        if scrollView.isDragging {
            if state == .idle, isScrolledOverReadyOffset {
                state = .ready // 转为即将刷新状态
            } else if state == .ready, !isScrolledOverReadyOffset {
                state = .idle // 转为普通状态
            }
        } else {
            // 即将刷新 && 手松开
            if state == .ready {
                beginRefresh() // 开始刷新
            }
        }
    }

    private var isScrolledOverReadyOffset: Bool {
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
}

// MARK: - Private

private extension YYRefresh {
    func visableCheckAutomatic() {
        guard config.visableCheckAutomatic else {
            return
        }

        visableCheck()
    }

    func layoutViews() {
        var x = CGFloat(0)
        var y = CGFloat(0)
        let viewWidth = scrollView.bounds.width
        let viewHeight = config.viewHeight
        switch position {
        case .top:
            y -= viewHeight
        case .bottom:
            y = scrollView.contentSize.height
        case .left:
            /// 在左右方向加刷新控件时，采用的方式是，将refreshView顺时针旋转90度，
            /// 旋转选择的是左上角那个点，所以这里x的要额外加refreshView的高度
            x = -viewHeight + viewHeight
            y = (scrollView.bounds.height - viewWidth) / 2
        case .right:
            x = max(scrollView.contentSize.width, scrollView.bounds.width) + viewHeight
            y = (scrollView.bounds.height - viewWidth) / 2
        }
        transform = .identity
        _setAnchorPointFixedFrame(.init(x: 0.5, y: 0.5))
        frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
        refreshView.view.frame = bounds

        if position == .left || position == .right {
            _setAnchorPointFixedFrame(.zero)
            transform = CGAffineTransform.identity.rotated(by: YYRefresh.degreesToRadians(90))
        }
        visableCheckAutomatic()
    }

    /// 增加或减少滚动区域
    func parkVisible(_ visible: Bool) {
        guard let scrollView = scrollView else { return }
        // 同时只能显示一个 parking 状态
        var contentInset = scrollViewOriginalInset
        var contentOffset = scrollView.contentOffset
        // 增加滚动区域
        let offset = visible ? config.viewHeight : 0
        switch position {
        case .top:
            contentInset.top += offset
            contentOffset.y = visible ? -config.readyOffset : 0
        case .left:
            contentInset.left += offset
            contentOffset.x = visible ? -config.readyOffset : 0
        case .bottom:
            contentInset.bottom += offset
        // contentOffset.y += offset
        case .right:
            contentInset.right += offset
            // contentOffset.x += offset
        }
        // 设置滚动位置
        scrollView.contentOffset = contentOffset

        // 增加滚动区域
        scrollView.contentInset = contentInset
    }
}

///
private extension UIView {
    /// 设置view的anchorPoint，同时保证view的frame不改变
    func _setAnchorPointFixedFrame(_ anchorPoint: CGPoint) {
        let oldOrigin = frame.origin
        layer.anchorPoint = anchorPoint
        let newOrign = frame.origin
        let transition = CGPoint(x: newOrign.x - oldOrigin.x, y: newOrign.y - oldOrigin.y)
        center = CGPoint(x: center.x - transition.x, y: center.y - transition.y)
    }
}
