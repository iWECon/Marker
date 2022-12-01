//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    /// Position of arrow
    public enum ArrowPosition {
        case auto
        
        case left(offset: CGFloat = 0)
        case center(offset: CGFloat = 0)
        case right(offset: CGFloat = 0)
    }
    
}
