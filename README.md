# Marker

轻量、便捷、可配的引导提示。


## Preview

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

* Supports global acquisition of instances

`支持全局获取实例（通过 identifier)`

使用 `Marker.instance(from identifier: String) -> Marker?` 即可获取已显示的实例，并触发下一步操作 `marker?.showNext(triggleByUser: Bool)`


* Support event transparency, can trigger the next Marker at the same time

`支持事件透传, 可同时触发下一个 Marker`


* Support global definition of background color, you can also set the background color independently

`支持全局定义背景颜色，也可以独立设置背景颜色`


* Support rounded corners to follow the highlighted view

`支持圆角跟随高亮视图`


* Support timeout time setting, can be configured globally, also can be set according to business needs for individual guidance

`支持超时时间设定，可全局配置，也可根据业务需求对单独的引导进行设置`


* Support highlighting range extension

`支持高亮范围扩展`


* Support show/hide triangle arrows

`支持显示/隐藏三角箭头`


* Support triggering response only when clicking on the highlighted range

`支持仅点击高亮范围时触发响应, 可配合 isEventPenetration 参数产生强引导（必须点击之后才触发下一个事件）`


* No calculation required (calculation of relative position, etc.)

`无需任何计算（相对位置等计算）`

* Configurable triangle arrow location

`可配置三角箭头所在位置（左/中/右）且支持设置偏移量`


## Install

#### Swift Package Manager

```swift
# for Swift 5.4, 最低支持 iOS 9.0
.package(url: "https://github.com/iWECon/Marker", from: "2.0.0")
```
