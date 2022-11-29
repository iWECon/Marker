//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum Style {
        case hideArrow
        case color(Color)
        case arrowPosition(ArrowPosition)
        case dimFrame(CGRect)
        case highlightRangeExpande(CGFloat)
        case timeout(TimeInterval)
        case maxWidth(CGFloat)
        case cornerStyle(CornerStyle)
    }
    
}

extension Marker.Info.Style: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.hideArrow, .hideArrow):
            return true
            
        case (.color(_), .color(_)):
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
            
        default:
            return false
        }
    }
    
}
