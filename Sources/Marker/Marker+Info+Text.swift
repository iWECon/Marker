//
//  Created by bro on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public struct Intro {
        
        /// String or NSAttributedString
        public var text: Any?
        
        let font: UIFont
        let color: UIColor
        
        public init(
            _ text: Any?,
            font: UIFont = Marker.default.textFont,
            color: UIColor = Marker.default.textColor
        ) {
            self.text = text
            self.font = font
            self.color = color
        }
    }
    
}
