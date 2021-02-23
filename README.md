# Marker

轻量、便捷、可配的引导提示。


## Preview

![Demo](Demo/preview.gif)


## Code Preview

```swift
Marker(.init(marker: bottomLeftButton, intro: "你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的", prefixImage:          .init(UIImage(named: "panci")), suffixImage: .init(UIImage(named: "panci")), maxWidth: 400))
    .next(.init(marker: topLeftButton, intro: "我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的", maxWidth: 320, style: .round))
    .next(.init(marker: topRightButton, intro: "她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的", maxWidth: 320, dimFrame: .zero))
    .next(.init(marker: buttons.first, intro: "第一个", highlightOnly: true, completion: { (_, isTriggerByUser) in
        print("is trigger by user: ", isTriggerByUser)
    }))
    .next(.init(marker: buttons[1], intro: "第二个", completion: { (_, isTriggerByUser) in
        print("is trigger by user: ", isTriggerByUser)
    }))
    .next(.init(buttons[2], intro: "第三个"))
    .next(.init(buttons[3], intro: "第四个"))
    .next(.init(marker: bottomRightButton, intro: "它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的", maxWidth: 320, enlarge: 20))
    .show(on: view)
```


## Features

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

# for Swift 5.0
.package(url: "https://github.com/iWECon/Marker", from: "1.0.0")

# for Swift 5.4
.package(url: "https://github.com/iWECon/Marker", from: "2.0.0")
```
