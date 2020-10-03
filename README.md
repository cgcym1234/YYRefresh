很久以前接到过一个需求，类似淘宝详情页，当商品左滑到尽头后需要做一些特定展示。

和下拉刷新基本一样，不过是左拉刷新。。

正好有时间，所以就想干脆写个上下左右拉刷新也挺好的，于是就参考MJRefresh，撸了个OC版的。

随着Swift的越来越好，后面也顺势完成了Swift版本，经过多次迭代，感觉趋于完善，并且Swifty😀

- 支持上下左右四个方向，旋转

- 可以配置触发刷新阈值，是否悬停等各种参数
- 协议化的自定义view

## 要求

- iOS 8.0+ 
- Swift 5.0+

## 安装

```
pod 'YYRefresh'
```

## 使用

### 最简单的使用

使用默认配置，默认的刷新view：

```
scrollView.addYYRefresh(position: .top) { refresh in
    xxx
}
```

### 自定义配置

默认配置如下：

```
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

/// 使用config
scrollView.addYYRefresh(position: .top, config: config) { refresh in
    xxx
}
```

### 自定义显示的view

如果要使用自定义的view，只需要使用实现YYRefreshView协议的控件即可：

```
/// 自定义RefreshView必须实现的协议
public protocol YYRefreshView: class {
        /// 真正的view
    var view: UIView { get }
    /// 不同状态时的显示
    func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool)
}
```

定义一个自己的view:

```
class TopRefreshDemoView: UIView {}

extension TopRefreshDemoView: YYRefreshView {
    var view: UIView { self }
    func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool) {
        
    }
}
```

使用：

```
scrollView.addYYRefresh(position: .top,
                        config: config,
                        refreshView: TopRefreshDemoView()) { refresh in
    xxx
}
```

## 一些实现说明

上下方向的刷新控件很常见，主要参考了MJRefresh，

这里简单说下左右方向的实现方式：

- 在左右方向加刷新控件时，采用的方式是，将refreshView顺时针旋转90度
- 所以需要调整view的anchorPoint到{0, 0}，调整同时要保持frame不变，用到了下面的扩展

```
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
```


## License

YYRefresh is available under the MIT license. See the LICENSE file for more info.
