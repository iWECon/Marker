//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum CornerStyle {
        /// Default. Follow `marker.layer.cornerRadius`.
        case marker
        
        case square
        
        /// radius = height/2
        case round
        
        /// custom the corner radius
        case radius(_ radius: CGFloat)
    }
}
