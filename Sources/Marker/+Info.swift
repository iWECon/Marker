//
//  Created by iWw on 2021/1/26.
//

import UIKit

extension Marker {
    
    public struct Info {
        
        /// 需要高亮的视图
        weak var marker: UIView?
        
        /// 表述文本 (supports String or NSAttributedString)
        let intro: Any?
        
        /// 文本的最大宽度，默认为 240，一般情况下无需调整
        let maxWidth: CGFloat
        
        /// 灰色背景的范围，默认为全屏，有非全屏需求时设置
        let dimFrame: CGRect
        
        /// 高亮部分的圆角度数，默认跟随 marker.layer.cornerRadius
        let style: Style
        
        /// 三角形位置, 默认为自动
        /// 可选择 左/中/右, 并附带偏移量
        let trianglePosition: ArrowPosition
        
        /// 颜色信息，默认走全局配置
        let color: Info.Color
        
        /// 出现后不操作自动下一个/结束的时间
        let timeout: TimeInterval
        
        /// 高亮范围扩展
        let enlarge: CGFloat
        
        let options: [Options]
        
        /// completion of this Info(next/init), all of done completion in show(on:completion)
        /// 本次完成的回执，全部完成的回执在 Marker 中的 show(on:completion:)
        let completion: CompletionBlock?
        
        var identifier: String {
            "\(marker?.description ?? "")-\(String(describing: intro))-\(dimFrame)-\(timeout)-\(style)"
        }
        
        public init(marker: UIView?,
                    intro: Any?,
                    maxWidth: CGFloat = 240,
                    style: Info.Style = Marker.default.style,
                    trianglePosition: ArrowPosition = Marker.default.trianglePosition,
                    color: Color = Marker.default.color,
                    timeout: TimeInterval = Marker.default.timeout,
                    dimFrame: CGRect = UIScreen.main.bounds,
                    enlarge: CGFloat = 0,
                    options: [Options] = [],
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
            self.options = options
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
