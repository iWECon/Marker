//
//  Created by i on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public struct Color {
        var colors: [CGColor]?
        var startPoint: CGPoint = .init(x: 0, y: 0.5)
        var endPoint: CGPoint = .init(x: 1, y: 0.5)
        var locations: [NSNumber]?
        
        public init(colors: [UIColor], startPoint: CGPoint = .init(x: 0, y: 0.5), endPoint: CGPoint = .init(x: 1, y: 0.5), locations: [NSNumber]? = nil) {
            self.colors = colors.map({ $0.cgColor })
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.locations = locations
        }
    }
    
    
}
