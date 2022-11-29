# Marker

轻量，便捷，可配置的引导提示。

# Preview

![Demo](Demo/preview.gif)

## Code Preview

通用代码

Marker.Info 中有多种配置，可自行查看

```swift
let startInfo = Marker.Info(marker: startButton, intro: "起始按钮, 默认配置, 最大宽度 320, 点击任意处进入下一个", trianglePosition: .left(offset: 0))
let number2Info = Marker.Info(marker: number2Button, intro: "第二个按钮, 默认配置", trianglePosition: .right(offset: 0))
let actionInfo = Marker.Info(marker: respondActionButton, intro: "第三个按钮, 可透传事件：仅点击高亮范围有效，且点击事，事件可以传递到按钮上（执行按钮的点击事件）并触发下一步事件", highlightOnly: true, eventPenetration: true)
let noMaskInfo = Marker.Info(marker: noMaskButton, intro: "第四个按钮, 没有遮罩", trianglePosition: .center(offset: 0), dimFrame: .zero)
let roundStyleInfo = Marker.Info(marker: roundButton, intro: "第五个按钮, 圆角遮罩, 且高亮范围有 10px 的扩张", style: .round, enlarge: 10)
let squareStyleInfo = Marker.Info(marker: squareButton, intro: "第六个按钮, 方形遮罩", style: .square)
let followStyleInfo = Marker.Info(marker: followStyleButton, intro: "第七个按钮, 跟随视图的风格, 视图是圆角就是圆角，方形就是方形, 高亮范围有 4px 的扩张", style: .marker, enlarge: 4)

Marker(identifier: "normal", start: startInfo)
    .nexts([number2Info, actionInfo, noMaskInfo, roundStyleInfo, squareStyleInfo, followStyleInfo])
    .show(on: self.view, completion: nil)
```

全局获取实例，并进行到下一步
```swift
let alert = UIAlertController(title: "透传事件", message: "你点击了透传按钮, 且按下`知道了`的时候会触发下一步引导", preferredStyle: .alert)
alert.addAction(.init(title: "知道了", style: .cancel, handler: { _ in
    // 通过 instance(from:) 获取
    Marker.instance(from: "normal")?.showNext(triggerByUser: true)
}))
self.present(alert, animated: true, completion: nil)
```


## Features

* `无需任何计算（相对位置等计算）`, No calculation required (calculation of relative position, etc.)

* `支持全局获取实例（通过 identifier)`, Supports global acquisition of instances

```swift
static func instance(from identifier: String) -> Marker?

use:
// 创建和显示 Create and show
Marker(startInfo, identifier: "demoGuide").show(on: self.view)

// 获取实例并操作显示下一个或者使其消失 Get instance and show next or dismiss
let instance: Marker? = Marker.instance(from: "demoGuide")
instance?.showNext(triggerByUser: true)
instance?.dismiss(triggerByUser: true)
```

* `支持事件透传`, Support event delivery

```swift
Marker.Info(marker: doneButton, intro: "完成~", highlightOnly: true, eventPenetration: true)

`highlightOnly` 和 `eventPenetration` 同时为 true 时，只能点击高亮范围(doneButton)才有响应，同时会响应 doneButton 的点击事件。

如需要对 marker 进行操作，可使用上面的获取全局实例。
```

* `支持全局定义背景颜色，也可以独立设置背景颜色`, Support global definition of background color, you can also set the background color independently

全局所有可配置的内容在 `+Appearence.swift` 文件中，可自行查阅。

CODE: `Marker.default.[property]`

* `支持圆角跟随高亮视图`, Support rounded corners to follow the highlighted view

默认行为：高亮的圆角跟随高亮视图。也可以自定义圆角度数。

```swift
`Marker.Info(... style: Style)`

enum Style {
    /// follow marker.layer.cornerRadius, default
    case marker
    
    case square
    
    /// radius = height/2
    case round
    
    /// custom the corner radius
    case radius(_ radius: CGFloat)
}
```

* `支持超时时间设定，可全局配置，也可根据业务需求对单独的引导进行设置`, Support timeout time setting, can be configured globally, also can be set according to business needs for individual guidance

```swift
全局配置超时时间：
Marker.default.timeout = newValue

全局所有可配置的内容在 `+Appearence.swift` 文件中，可自行查阅。
```

* `支持高亮范围扩展`, Support highlighting range extension

`Marker.Info(... enlarge: CGFloat)`

* `支持显示/隐藏三角箭头`, Support show/hide triangle arrows

`Marker.Info(... showArrow: Bool)`

* `可配置三角箭头所在位置（左/中/右）且支持设置偏移量`, Configurable triangle arrow location

```swift
`Marker.Info(... trianglePosition: TrianglePosition)`

/// 三角箭头所在位置
public enum TrianglePosition {
    /// 自动处理
    case auto
    
    /// 在左侧
    case left(offset: CGFloat = 0)
    /// 在中间
    case center(offset: CGFloat = 0)
    /// 在右侧
    case right(offset: CGFloat = 0)
}
```
