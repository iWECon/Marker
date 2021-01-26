//
//  Created by iWw on 2021/1/26.
//

import UIKit

public extension Marker {
    
    struct Info {
        /// 需要高亮的视图
        public weak var marker: UIView?
        
        /// 表述文本
        public var intro: String
        
        /// 前缀图片
        public var prefixImage: Image?
        
        /// 后缀图片
        public var suffixImage: Image?
        
        /// 文本的最大宽度，默认为 240，一般情况下无需调整
        public var maxWidth: CGFloat
        
        /// 灰色背景的范围，默认为全屏，有非全屏需求时设置
        public var dimFrame: CGRect = UIScreen.main.bounds
        
        /// 高亮部分的圆角度数，默认跟随 marker.layer.cornerRadius
        public var style: Style
        
        /// 出现后不操作自动下一个/结束的时间
        public var timeout: TimeInterval
        
        /// 高亮范围扩展
        public var enlarge: CGFloat
        
        /// 显示三角箭头
        public var isShowArrow = true
        
        /// Valid only when clicking on the highlighted range
        /// 仅在高亮视图点击才有响应/才会走到下一步, 默认为 false
        public var isOnlyAcceptHighlightRange = false
        
        /// completion of this Info(next/init), all of done completion in show(on:completion)
        /// 本次完成的回执，全部完成的回执在 Marker 中的 show(on:completion:)
        public var completion: CompletionBlock?
        
        var identifier: String {
            "\(marker?.description ?? "")-\(intro)-\(dimFrame)-\(timeout)-\(style)"
        }
        
        public init(marker: UIView?,
                    intro: String,
                    prefixImage: Image? = nil,
                    suffixImage: Image? = nil,
                    maxWidth: CGFloat = 240,
                    style: Info.Style = Marker.default.style,
                    timeout: TimeInterval = Marker.default.timeout,
                    dimFrame: CGRect = UIScreen.main.bounds,
                    enlarge: CGFloat = 0,
                    showArrow: Bool = Marker.default.isShowArrow,
                    highlightOnly: Bool = false,
                    completion: CompletionBlock? = nil) {
            self.marker = marker
            self.intro = intro
            self.prefixImage = prefixImage
            self.suffixImage = suffixImage
            self.maxWidth = maxWidth
            self.dimFrame = dimFrame
            self.style = style
            self.timeout = timeout
            self.enlarge = enlarge
            self.isOnlyAcceptHighlightRange = highlightOnly
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
        case round
        /// custom the corner radius
        case radius(_ radius: CGFloat)
    }
}

public extension Marker.Info {
    struct Image {
        public var image: UIImage?
        public var offsetY: CGFloat
        /// get value from image if nil.
        public var size: CGSize?
        
        public init(_ image: UIImage?, offsetY: CGFloat = 0, size: CGSize? = nil) {
            self.image = image
            self.offsetY = offsetY
            self.size = size
        }
        
        public init(_ imageName: String, offsetY: CGFloat = 0, size: CGSize? = nil) {
            self.init(UIImage(named: imageName), offsetY: offsetY, size: size)
        }
        
        @available(*, deprecated, message: "Please use init(_:offsetY:size:) instead.")
        public static func image(_ image: UIImage?, offsetY: CGFloat = 0, size: CGSize? = nil) -> Image {
            self.init(image, offsetY: offsetY, size: size)
        }
    }
}
