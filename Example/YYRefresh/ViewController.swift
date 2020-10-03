//
//  ViewController.swift
//  YYRefresh
//
//  Created by cgcym1234 on 10/03/2020.
//  Copyright (c) 2020 cgcym1234. All rights reserved.
//

import UIKit
import YYRefresh

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        edgesForExtendedLayout = []
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        addRefresh()
        scrollView.yy_topRefresh?.beginRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.yy_topRefresh?.beginRefresh()
    }
    
    func addScrollView() {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = true
        scrollView.contentSize = view.bounds.size
        view.addSubview(scrollView)
        self.scrollView = scrollView
        
        let label = UILabel()
        label.text = "上下左右拖动"
        label.sizeToFit()
        label.textColor = .orange
        label.center = scrollView.center
        scrollView.addSubview(label)
    }
    
    func addRefresh() {
        var config = YYRefresh.Config.default
        /// 不同状态显示文案，默认是top位置的
        config.textIdle = "下拉可以刷新"
        config.textReady = "松开立即刷新"
        config.textRefreshing = "正在刷新..."
        config.textNoMore = "没有更多数据了..."
        
        /// 刷新控件高度，自定义view的时候可以按需设置
        config.viewHeight = 50
        
        /// 触发刷新需要滚动的阈值
        config.readyOffset = 50
        
        /// right和bottom位置是否需要当contentSize不足一屏的时候自动隐藏
        config.visableCheckAutomatic = false
        
        /// 触发刷新阈值后，是否悬停等待
        config.parkVisible = true
        
        /// 悬停状态出现或消失的动画时间
        config.animateDurationParking = 0.25
        
        /// 不同状态切换时的动画时间
        config.animateDurationStateSwitching = 0.4
        
        scrollView.addYYRefresh(position: .top,
                                config: config,
                                refreshView: nil) { refresh in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                refresh.endRefresh()
            }
        }
        
        scrollView.addYYRefresh(position: .bottom, config: config) { refresh in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                refresh.endRefresh()
            }
        }
        
        scrollView.addYYRefresh(position: .right, config: config) { refresh in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                refresh.endRefresh()
            }
        }
        
        scrollView.addYYRefresh(position: .left, config: config) { refresh in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                refresh.endRefresh()
            }
        }
    }
}

class TopRefreshDemoView: UIView {}

extension TopRefreshDemoView: YYRefreshView {
    var view: UIView { self }
    
    func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool) {
        
    }
}

