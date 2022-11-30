//
//  Created by iWw on 2021/1/26.
//

import UIKit

extension Marker {
    
    /// Global appearence of Marker
    public struct Appearence {
        
        public typealias Color = Info.Color
        
        public var color: Color = Color(colors: [
            UIColor(red: 255 / 255, green: 200 / 255, blue: 0, alpha: 1),
            UIColor(red: 255 / 255, green: 51 / 255, blue: 131 / 255, alpha: 1)
        ])
        
        public var maxWidth: CGFloat = 240
        public var textFont: UIFont = .systemFont(ofSize: 12, weight: .medium)
        public var textColor: UIColor = .white
        
        /// Spacing between triangle arrow and highlight view.
        public var spacing: CGFloat = 6
        
        /// Padding of intro(text/description).
        public var padding: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        /// Default is `true`.
        public var timeoutAfterAnimateDidCompletion = true
        
        /// Describe highlight corner style. Default is `.marker`.
        public var style: Info.CornerStyle = .marker
        
        /// 0: never time out. Default is `0`.
        public var timeout: TimeInterval = 0
        
        /// Display triangle arrow. Default is `true`.
        public var isShowArrow = true
        
        /// Triangle position. Default is `.auto`.
        public var trianglePosition: Info.ArrowPosition = .auto
    }
    
}
