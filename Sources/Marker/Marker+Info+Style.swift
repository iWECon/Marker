//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum Style {
        
        case hideArrow
        
        /// font of intro text
        case font(UIFont)
        /// text color of intro text
        case textColor(UIColor)
        
        case backgroundColor(Color)
        
        case arrowPosition(ArrowPosition)
        
        case dimFrame(CGRect)
        
        case highlightRangeExpande(CGFloat)
        
        case timeout(TimeInterval)
        
        /// max width of intro text
        case maxWidth(CGFloat)
        
        /// corner style of highlight range
        case cornerStyle(CornerStyle)
        
        /// horizontal alignment
        case hAlignment(HAlignment)
        
        /// vertical alignment
        case vAlignment(VAlignment)
        
        /// Spacing between triangle arrow and highlighted view.
        /// Default value see `Marker.default.spacing`.
        case spacing(CGFloat)
    }
    
}

extension Marker.Info.Style: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.hideArrow, .hideArrow):
            return true
            
        case (.font(_), .font(_)):
            return true
        case (.textColor(_), .textColor(_)):
            return true
        case (.backgroundColor(_), .backgroundColor(_)):
            return true
            
        case (.arrowPosition(_), .arrowPosition(_)):
            return true
            
        case (.dimFrame(_), .dimFrame(_)):
            return true
            
        case (.highlightRangeExpande(_), .highlightRangeExpande(_)):
            return true
            
        case (.timeout(_), .timeout(_)):
            return true
            
        case (.maxWidth(_), .maxWidth(_)):
            return true
            
        case (.cornerStyle(_), .cornerStyle(_)):
            return true
            
        case (.hAlignment(_), .hAlignment(_)):
            return true
        case (.vAlignment(_), .vAlignment(_)):
            return true
            
        case (.spacing(_), .spacing(_)):
            return true
            
        default:
            return false
        }
    }
    
}
