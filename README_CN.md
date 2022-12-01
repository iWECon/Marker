# Marker

轻量，便捷，可配置的引导提示。

# Preview

![Demo](Demo/preview-new.gif)


# 功能

- 简单。

简单的 API，简单的用法，简单的配置。

- 无计算。

不需要手动计算相对位置等。

- 可装饰。

可将视图用作固定显示的 UIView 且不处理任何点击事件。(hitTest:) 总是返回 nil。

- 全局。

全局样式配置，全局实例获取，全局 dismiss。

- 强弱引导。

弱引导：点击屏幕任意位置都可跳转到下一步。（默认）

强引导：仅点击高亮范围才能进行下一步。

强引导需要配置 options: `[.strongGuidance]`。

# 用法示例

### Marker.Info 解释

`Marker.Info` 是一个描述 Marker 如何显示的结构体。

```swift
Marker.Info(
    // 需要高亮显示的视图
    marker: UIView?,
    
    // String 或者 NSAttributedString
    intro: Any?, 
    
    // Marker 显示的样式
    styles: [Marker.Info.Style] = [],
    // 一些可配置的额外选项
    options: [Options] = [],
    
    // 当前引导显示完成的回执 (这里仅单个)
    completion: CompletionBlock? = nil
)


styles: [Marker.Info.Style]: [
    // 隐藏 三角 箭头
    case hideArrow
    
    // 引导文本的字体
    case font(UIFont)
    // 引导文本的字体颜色
    case textColor(UIColor)
    
    // 背景
    case backgroundColor(Color)
    // 三角箭头的位置
    case arrowPosition(ArrowPosition)
    // 灰底背景 frame
    case dimFrame(CGRect)
    // 高亮范围扩展
    case highlightRangeExpande(CGFloat)
    // 超时时间
    case timeout(TimeInterval)
    // 引导文本的最大宽度
    case maxWidth(CGFloat)
    // 高亮范围的圆角样式
    case cornerStyle(CornerStyle)
    
    // 横向对齐方式
    case hAlignment(HAlignment)
    // 纵向对齐方式
    case vAlignment(VAlignment)
    
    // 三角箭头 到 高亮范围的间距
    case spacing(CGFloat)
]

options: [Options]: [
    // 强引导
    // 即：只有点击高亮范围才可触发下一步。
    .strongGuidance,
    
    // 事件穿透
    // 即：如果高亮视图是 Button，则会响应 Button 的点击事件。Marker 不再响应任何触摸事件。
    .eventPenetration,
    
    // 装饰
    // 用作装饰，Marker 不响应任何点击事件，同时会将 dimFrame 设置为 `.zero`。
    .decoration
]
```

### 全局样式配置

使用 `Marker.default` 即可进行全局样式配置。

可配置：`maxWidth`, `color`, `spacing`, `padding`, `textFont`, `textColor`, `showArrow`...

更多详情查看 `Marker+Appearence.swift`。


### 正常使用

```swift
let info = Marker.Info(
    marker: settingsButton, 
    intro: "Tap here enter to settings.",
    styles: [
        .dimFrame(.zero)
    ],
    options: [.decoration],
    completion: { (markerInstance: Marker, isTriggerByUser: Bool) in
        print("marker of enter settings dismiss with user: \(isTriggerByUser)")
    }
)

let profile = Marker.Info(
    marker: profileButton, 
    intro: "Tap here to edit your profile."
)

// 这里注意 ⚠️，`.show(on:completion:)` 这里的 completion 是所有引导都完成的时候触发的。

Marker(info)
    .nexts([profile])
    .show(
        on: self.view,
        completion: { (markerInstance: Marker, isTriggerByUser: Bool) in 
            print("marker of enter to settings and profile are all of dismiss")
        }
    )
```

### 水平位置 / 垂直位置

#### \#HAlignment

描述 Marker 与高亮视图是左对齐还是右对齐。

```swift
public enum HAlignment {
    /// `Default` if available.
    case center
    
    case left
    case right
}

Marker.Info(... styles: [.hAlignment(Marker.Info.HAlignment)])
```

#### \#VAlignment

描述 Marker 与高亮视图的上下关系。
```swift
public enum VAlignment {
    // `默认`. 自动处理。 
    case auto
    
    // Marker 显示在高亮视图上方。
    case top
    // Marker 显示在高亮视图下方。 
    case bottom
}

Marker.Info(... styles: [.vAlignment(Marker.Info.VAlignment)])
```

### 全局

```swift
// Marker 初始化时可配置 identifier
Marker(info, identifier: "settings-marked").show(on: self.view)

// 可使用 instance(from:) 来获取显示中的 Marker 实例
Marker.instance(from: "settings-marked")?.dismiss()

// 所有 Marker dismiss
Marker.dismiss(triggerByUser: <#Bool#>)
```


# 💡

更多样式配置等，可下载 Demo 查看，或查看相关 API：

`Marker+Info+Style.swift` 所有样式配置。

## Install

#### Swift Package Manager

```swift
.package(url: "https://github.com/iWECon/Marker", from: "3.0.0")
```
