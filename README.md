# Marker

轻量、便捷、可配的引导提示。


## Preview

![Demo](Demo/preview.gif)


## Code Preview

```swift
Marker(.init(marker: bottomLeftButton, intro: "这是左下角的按钮 BottomLeft", prefixImage: .init(UIImage(named: "panci")), suffixImage: .init(UIImage(named: "panci"))))
    .next(.init(marker: topLeftButton, intro: "右上角左边的按钮 TopLeft of Right, 该按钮仅点击高亮范围有效, 且点击事件会穿透下来. 该操作需要 highlightOnly 和 eventPenetration 同时为 true", maxWidth: 320, highlightOnly: true, eventPenetration: true))
    .next(.init(marker: topRightButton, intro: "这里的文本最大宽度可能超出320，但是设置了最大宽度为200，所以自动收缩了! \n这里的文本最大宽度可能超出200，但是设置了最大宽度为200，所以自动收缩了!\nTopRight of Right", maxWidth: 200))
    .next(.init(marker: buttons.first, intro: "遍历生成的第一个按钮，仅点击高亮范围才会触发下一步, 没有事件穿透.", highlightOnly: true, completion: { (_, isTriggerByUser) in
    print("is trigger by user: ", isTriggerByUser)
    }))
    .next(.init(marker: buttons[1], intro: "遍历生成的第二个按钮", completion: { (_, isTriggerByUser) in
    print("is trigger by user: ", isTriggerByUser)
    }))
    .next(.init(marker: buttons[2], intro: "遍历生成的第二个按钮"))
    .next(.init(marker: buttons[3], intro: "遍历生成的第二个按钮"))
    .next(.init(marker: bottomRightButton, intro: "右下角的按钮，使用 Enlarge 参数扩展了高亮范围.", maxWidth: 320, enlarge: 20))
    .show(on: view)
```


## Features

```
Support event transparency, can trigger the next Marker at the same time

支持事件透传, 可同时触发下一个 Marker
```

```
Support global definition of background color, you can also set the background color independently

支持全局定义背景颜色，也可以独立设置背景颜色
```

```
Support rounded corners to follow the highlighted view

支持圆角跟随高亮视图
```

```
Support timeout time setting, can be configured globally, also can be set according to business needs for individual guidance

支持超时时间设定，可全局配置，也可根据业务需求对单独的引导进行设置
```

```
Support highlighting range extension

支持高亮范围扩展
```

```
Support show/hide triangle arrows

支持显示/隐藏三角箭头
```

```
Support triggering response only when clicking on the highlighted range

支持仅点击高亮范围时触发响应
```

```
No calculation required (calculation of relative position, etc.)

无需任何计算（相对位置等计算）
```


## Install

#### Swift Package Manager

```swift
# for Swift 5.4, 最低支持 iOS 9.0
.package(url: "https://github.com/iWECon/Marker", from: "2.0.0")
```
