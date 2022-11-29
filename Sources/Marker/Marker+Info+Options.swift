//
//  Created by bro on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum Options {
        
        /// Strong guidance. It means that only tap on the highlighted range will respond.
        /// Default is weak guidance: tap anywhere to continue(next).
        case strongGuidance
        
        /// Will not repond any tap events.
        /// ⚠️ Need to be used with `strongGuidance`.
        case eventPenetration
        
        /// It means that only display on view, no event repond.
        /// It will set dimFrame to `.zero`.
        case decoration
    }
    
}


extension Marker.Info.Options: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.strongGuidance, .strongGuidance):
            return true
            
        case (.eventPenetration, .eventPenetration):
            return true
            
        case (.decoration, .decoration):
            return true
            
        default:
            return false
        }
    }
}
