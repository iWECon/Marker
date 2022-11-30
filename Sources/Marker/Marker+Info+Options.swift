//
//  Created by bro on 2022/11/29.
//

import UIKit

extension Marker.Info {
    
    public enum Options {
        
        /// Strong guidance. It means that only tap on the highlighted range will respond.
        /// Default is weak guidance: tap anywhere to continue(next).
        ///
        /// `强引导`，只有点击高亮范围才会响应下一步操作。
        case strongGuidance
        
        /// Will not repond any tap events. Pass the event to the next hitTestView.
        /// ⚠️ Need to be used with `strongGuidance`.
        ///
        /// `事件穿透`，需要与 `strongGuidance` 搭配使用，将触摸事件向高亮范围传递下去。
        /// 意思就是：如果高亮范围是个 Button，那么就会触发 Button 的点击事件。
        case eventPenetration
        
        /// It means that only display on view, no event repond.
        /// (hitTest always return nil)
        /// It will set dimFrame to `.zero`.
        ///
        /// 装饰器，使用后 dimFrame 会被标记为`.zero`，且装饰器一切触摸事件都会向下传递。
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
