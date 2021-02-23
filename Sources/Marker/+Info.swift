//
//  Created by iWw on 2021/1/26.
//

import UIKit

public extension Marker {
    
    struct Info {
        /// 需要高亮的视图
        weak var marker: UIView?
        
        /// 表述文本
        var intro: String
        
        /// 前缀图片
        var prefixImage: Image? = nil
        
        /// 后缀图片
        var suffixImage: Image? = nil
        
        /// 文本的最大宽度，默认为 240，一般情况下无需调整
        var maxWidth: CGFloat = 240
        
        /// 灰色背景的范围，默认为全屏，有非全屏需求时设置
        var dimFrame: CGRect = UIScreen.main.bounds
        
        /// 高亮部分的圆角度数，默认跟随 marker.layer.cornerRadius
        var style: Style = Marker.default.style
        
        /// 出现后不操作自动下一个/结束的时间
        var timeout: TimeInterval = 0
        
        /// 高亮范围扩展
        var enlarge: CGFloat = 0
        
        /// 显示三角箭头
        var isShowArrow = Marker.default.isShowArrow
        
        /// Valid only when clicking on the highlighted range
        /// 仅在高亮视图点击才有响应/才会走到下一步, 默认为 false
        var isOnlyAcceptHighlightRange = false
        
        /// completion of this Info(next/init), all of done completion in show(on:completion)
        /// 本次完成的回执，全部完成的回执在 Marker 中的 show(on:completion:)
        var completion: CompletionBlock? = nil
        
        var identifier: String {
            "\(marker?.description ?? "")-\(intro)-\(dimFrame)-\(timeout)-\(style)"
        }
        
        @available(*, deprecated, message: "Please use `init(_:intro:)` to initialize.")
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
        
        public init(_ marker: UIView?, intro: String) {
            self.marker = marker
            self.intro = intro
        }
        
    }
}

// MARK:- Chainable
public extension Marker.Info {
    
    @discardableResult
    mutating func image(prefix prefixImage: Image?) -> Marker.Info {
        self.prefixImage = prefixImage
        return self
    }
    @discardableResult
    mutating func image(suffix suffixImage: Image?) -> Marker.Info {
        self.suffixImage = suffixImage
        return self
    }
    @discardableResult
    mutating func style(_ style: Marker.Info.Style) -> Marker.Info {
        self.style = style
        return self
    }
    @discardableResult
    mutating func timeout(_ timeout: TimeInterval) -> Marker.Info {
        self.timeout = timeout
        return self
    }
    @discardableResult
    mutating func dim(frame: CGRect) -> Marker.Info {
        self.dimFrame = frame
        return self
    }
    @discardableResult
    mutating func enlarge(_ tapEnlarge: CGFloat) -> Marker.Info {
        self.enlarge = tapEnlarge
        return self
    }
    @discardableResult
    mutating func arrow(show isShow: Bool) -> Marker.Info {
        self.isShowArrow = isShow
        return self
    }
    @discardableResult
    mutating func highlight(only isOnlyAcceptHighlightRange: Bool) -> Marker.Info {
        self.isOnlyAcceptHighlightRange = isOnlyAcceptHighlightRange
        return self
    }
    @discardableResult
    mutating func completion(_ completion: @escaping Marker.CompletionBlock) -> Marker.Info {
        self.completion = completion
        return self
    }
    @discardableResult
    mutating func maxWidth(_ textMaxWidth: CGFloat) -> Marker.Info {
        self.maxWidth = textMaxWidth
        return self
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
