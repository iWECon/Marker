//
//  Created by i on 2022/11/30.
//

import UIKit

extension Marker.Info {
    
    /// Describe `Marker` horizotnally alignment.
    public enum HAlignment {
        /// `Default` if available.
        case center
        
        case left
        case right
    }
    
    /// Describe `Marker` vertically alignment.
    public enum VAlignment {
        /// `Default`.
        case auto
        
        /// Above the highlighted view.
        case top
        /// Below the highlighted view.
        case bottom
    }
}
