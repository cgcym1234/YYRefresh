# YYRefresh
支持上下左右四个方向的刷新控件，简单易用

## Usage

```
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
```

