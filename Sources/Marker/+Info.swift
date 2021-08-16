//
//  Created by iWw on 2021/1/26.
//

import UIKit

public extension Marker {
    
    struct Info {
        
        public enum TrianglePosition {
            case auto
            case left(offset: CGFloat = 0)
            case center(offset: CGFloat = 0)
            case right(offset: CGFloat = 0)
        }
        
        public struct Color {
            var colors: [CGColor]?
            var startPoint: CGPoint = .init(x: 0, y: 0.5)
            var endPoint: CGPoint = .init(x: 1, y: 0.5)
            var locations: [NSNumber]?
            
            public init(colors: [CGColor], startPoint: CGPoint = .init(x: 0, y: 0.5), endPoint: CGPoint = .init(x: 1, y: 0.5), locations: [NSNumber]? = nil) {
                self.colors = colors
                self.startPoint = startPoint
                self.endPoint = endPoint
                self.locations = locations
            }
        }
        
        /// 需要高亮的视图
        weak var marker: UIView?
        
        /// 表述文本 (supports String or NSAttributedString)
        var intro: Any?
        
        /// 文本的最大宽度，默认为 240，一般情况下无需调整
        var maxWidth: CGFloat = 240
        
        /// 灰色背景的范围，默认为全屏，有非全屏需求时设置
        var dimFrame: CGRect = UIScreen.main.bounds
        
        /// 高亮部分的圆角度数，默认跟随 marker.layer.cornerRadius
        var style: Style = Marker.default.style
        
        /// 三角形位置, 默认为自动
        /// 可选择 左/中/右, 并附带偏移量
        var trianglePosition: TrianglePosition = .auto
        
        /// 颜色信息，默认走全局配置
        var color: Info.Color
        
        /// 出现后不操作自动下一个/结束的时间
        var timeout: TimeInterval = 0
        
        /// 高亮范围扩展
        var enlarge: CGFloat = 0
        
        /// 显示三角箭头
        var isShowArrow = Marker.default.isShowArrow
        
        /// Valid only when clicking on the highlighted range
        /// 仅在高亮视图点击才有响应/才会走到下一步, 默认为 false
        var isOnlyAcceptHighlightRange = false
        
        /// 事件透传, 仅在 `isOnlyAcceptHighlightRange` 为 true 时有效
        var isEventPenetration = false
        
        /// completion of this Info(next/init), all of done completion in show(on:completion)
        /// 本次完成的回执，全部完成的回执在 Marker 中的 show(on:completion:)
        var completion: CompletionBlock? = nil
        
        var identifier: String {
            "\(marker?.description ?? "")-\(String(describing: intro))-\(dimFrame)-\(timeout)-\(style)"
        }
        
        public init(marker: UIView?,
                    intro: Any?,
                    maxWidth: CGFloat = 240,
                    style: Info.Style = Marker.default.style,
                    trianglePosition: TrianglePosition = Marker.default.trianglePosition,
                    color: Color = Marker.default.color,
                    timeout: TimeInterval = Marker.default.timeout,
                    dimFrame: CGRect = UIScreen.main.bounds,
                    enlarge: CGFloat = 0,
                    showArrow: Bool = Marker.default.isShowArrow,
                    highlightOnly: Bool = false,
                    eventPenetration: Bool = false,
                    completion: CompletionBlock? = nil) {
            self.marker = marker
            self.intro = intro
            self.maxWidth = maxWidth
            self.dimFrame = dimFrame
            self.style = style
            self.trianglePosition = trianglePosition
            self.color = color
            self.timeout = timeout
            self.enlarge = enlarge
            self.isOnlyAcceptHighlightRange = highlightOnly
            self.isEventPenetration = eventPenetration
            self.isShowArrow = showArrow
            self.completion = completion
        }
    }
}

public extension Marker.Info {
    
    enum Style {
        /// follow marker.layer.cornerRadius, default
        case marker
        
        case square
        
        /// radius = height/2
        case round
        
        /// custom the corner radius
        case radius(_ radius: CGFloat)
    }
}
