//
//  Created by iWw on 2021/1/26.
//

import UIKit

public extension Marker {
    
    class Info {
        
        /// 表述内容
        var intro: Any!
        
        /// 需要高亮的视图
        weak var marker: UIView?
        
        /// max width of the content, default is `240`
        /// 提示内容的最大宽度, 默认为 `240`
        var maxWidth: CGFloat = 240
        
        /// the dimming view's frame
        /// 灰色遮罩的 frame
        var dimFrame: CGRect = UIScreen.main.bounds
        
        /// corner style of the marker
        /// 圆角类型
        var style: Marker.Info.Style = Marker.default.style
        
        /// 超时时间
        var timeout: TimeInterval = Marker.default.timeout
        
        /// enlarge of the highlight range
        /// 高亮范围的扩展
        var enlarge: CGFloat = 0
        
        /// is show arrow
        /// 是否显示三角箭头
        var isShowArrow: Bool = Marker.default.isShowArrow
        
        /// is only accept highlight range, default is `false`
        /// only accept tap highlight range to next, if true
        /// 是否只允许高亮范围的点击事件, 默认为 `false`
        var isOnlyAcceptHighlightRange: Bool = false
        
        var completion: Marker.CompletionBlock? = nil
        
        var isMarkerNilToNext: Bool = false
        
        var identifier: String {
            "\(marker?.description ?? "")-\(String(describing: intro))-\(dimFrame)-\(timeout)-\(style)"
        }
        
        init() {}
    }
}


// MARK:- Chainable
public extension Marker.Info {
    
    @discardableResult
    func style(_ style: Marker.Info.Style) -> Marker.Info {
        self.style = style
        return self
    }
    @discardableResult
    func timeout(_ timeout: TimeInterval) -> Marker.Info {
        self.timeout = timeout
        return self
    }
    @discardableResult
    func dim(frame: CGRect) -> Marker.Info {
        self.dimFrame = frame
        return self
    }
    @discardableResult
    func enlarge(_ tapEnlarge: CGFloat) -> Marker.Info {
        self.enlarge = tapEnlarge
        return self
    }
    @discardableResult
    func arrow(show isShow: Bool) -> Marker.Info {
        self.isShowArrow = isShow
        return self
    }
    @discardableResult
    func highlight(only isOnlyAcceptHighlightRange: Bool) -> Marker.Info {
        self.isOnlyAcceptHighlightRange = isOnlyAcceptHighlightRange
        return self
    }
    @discardableResult
    func completion(_ completion: @escaping Marker.CompletionBlock) -> Marker.Info {
        self.completion = completion
        return self
    }
    
    @discardableResult
    func maxWidth(_ textMaxWidth: CGFloat) -> Marker.Info {
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


// MARK:- Helper for Marker calculator
extension Marker.Info {
    
    var isMarkerValidate: Bool {
        marker != nil && marker?.superview != nil
    }
    var markerView: UIView! {
        marker
    }
    var markerSuperview: UIView! {
        marker?.superview
    }
    
}
