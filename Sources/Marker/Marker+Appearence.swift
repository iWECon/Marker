//
//  Created by iWw on 2021/1/26.
//

import UIKit

extension Marker {
    
    /// Global appearence of Marker
    public struct Appearence {
        
        public typealias Color = Info.Color
        
        public var color: Color = Color(colors: [
            UIColor(red: 255 / 255, green: 200 / 255, blue: 0, alpha: 1).cgColor,
            UIColor(red: 255 / 255, green: 51 / 255, blue: 131 / 255, alpha: 1).cgColor
        ])
        
        public var maxWidth: CGFloat = 240
        
        /// Spacing between triangle arrow and highlight view.
        /// 三角箭头距离高亮视图的距离
        public var spacing: CGFloat = 10
        
        /// Padding of intro(text/description).
        /// 文本内容对应背景的间距
        public var padding: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        public var textFont: UIFont = .systemFont(ofSize: 12, weight: .medium)
        public var textColor: UIColor = .white
        
        /// 超时时间是否从动画完成后开始, 默认为 true
        public var timeoutAfterAnimateDidCompletion = true
        
        /// 高亮区域圆角配置，默认为跟随高亮视图 .marker
        public var style: Info.CornerStyle = .marker
        
        /// 超时时间，0 为永不超时
        public var timeout: TimeInterval = 0
        
        /// 是否显示三角箭头, 默认为 true
        public var isShowArrow = true
        
        /// 默认的三角箭头所在位置（自动处理）
        public var trianglePosition: Info.ArrowPosition = .auto
    }
    
}
