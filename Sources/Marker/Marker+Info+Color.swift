//
//  Created by bro on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public struct Color {
        public var colors: [CGColor]?
        public var startPoint: CGPoint = .init(x: 0, y: 0.5)
        public var endPoint: CGPoint = .init(x: 1, y: 0.5)
        public var locations: [NSNumber]?
        
        public init(colors: [CGColor], startPoint: CGPoint = .init(x: 0, y: 0.5), endPoint: CGPoint = .init(x: 1, y: 0.5), locations: [NSNumber]? = nil) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.locations = locations
        }
    }
    
    
}
