//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum CornerStyle {
        /// follow marker.layer.cornerRadius, `default`
        case marker
        
        case square
        
        /// radius = height/2
        case round
        
        /// custom the corner radius
        case radius(_ radius: CGFloat)
    }
}
