//
//  YYRefreshDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class YYRefreshDemo: UIViewController {
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
        addScrollView()
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
        var config = YYRefresh.Config()
        config.textIdle = "下拉返回商品详情"
        config.textReady = "释放返回商品详情"
        
        scrollView.addYYRefresh(position: .top, config: config, refreshView: nil) { (refresh) in
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                refresh.endRefresh()
            })
        }
        
        scrollView.addYYRefresh(position: .left, config: config) { (refresh) in
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                refresh.endRefresh()
            })
        }
        
        scrollView.addYYRefresh(position: .bottom) { (refresh) in
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                refresh.endRefresh()
            })
        }
        
        scrollView.addYYRefresh(position: .right) { (refresh) in
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                refresh.endRefresh()
            })
        }
    }
    
    
    
}







