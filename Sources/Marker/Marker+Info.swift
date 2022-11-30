//
//  Created by iWw on 2021/1/26.
//

import UIKit

extension Marker {
    
    public struct Info {
        
        weak var marker: UIView?
        
        /// Support `String` or `NSAttributedString`.
        let intro: Any?
        
        let maxWidth: CGFloat
        var dimFrame: CGRect
        let style: CornerStyle
        let trianglePosition: ArrowPosition
        let backgroundColor: Info.Color
        let font: UIFont
        let textColor: UIColor
        let timeout: TimeInterval
        let enlarge: CGFloat
        
        let isArrowHidden: Bool
        let isStrongGuidance: Bool
        let isEventPenetration: Bool
        let isDecoration: Bool
        
        let completion: CompletionBlock?
        
        var identifier: String {
            "\(marker?.description ?? "")-\(String(describing: intro))-\(dimFrame)-\(timeout)-\(style)"
        }
        
        public init(marker: UIView?,
                    intro: Any?,
                    styles: [Marker.Info.Style] = [],
                    options: [Options] = [],
                    completion: CompletionBlock? = nil) {
            self.marker = marker
            self.intro = intro
            
            if styles.contains(.hideArrow) {
                self.isArrowHidden = true
            } else {
                self.isArrowHidden = !Marker.default.isShowArrow
            }
            
            if let fontStyle = styles.first(where: { $0 == .font(UIFont()) }),
               case .font(let value) = fontStyle
            {
                self.font = value
            } else {
                self.font = Marker.default.textFont
            }
            
            if let colorStyle = styles.first(where: { $0 == .textColor(.white) }),
               case .textColor(let value) = colorStyle
            {
                self.textColor = value
            } else {
                self.textColor = Marker.default.textColor
            }
            
            if let colorStyle = styles.first(where: { $0 == .backgroundColor(Color(colors: [])) }),
               case .backgroundColor(let value) = colorStyle
            {
                self.backgroundColor = value
            } else {
                self.backgroundColor = Marker.default.color
            }
            
            if let arrowPositionStyle = styles.first(where: { $0 == .arrowPosition(.auto) }),
               case .arrowPosition(let position) = arrowPositionStyle
            {
                self.trianglePosition = position
            } else {
                self.trianglePosition = .auto
            }
            
            if let maxWidthStyle = styles.first(where: { $0 == .maxWidth(0) }),
               case .maxWidth(let maxWidth) = maxWidthStyle
            {
                self.maxWidth = maxWidth
            } else {
                self.maxWidth = Marker.default.maxWidth
            }
            
            if let dimFrameStyle = styles.first(where: { $0 == .dimFrame(.zero) }),
               case .dimFrame(let dimFrame) = dimFrameStyle
            {
                self.dimFrame = dimFrame
            } else {
                self.dimFrame = UIScreen.main.bounds
            }
            
            if let highlightRangeExpandeStyle = styles.first(where: { $0 == .highlightRangeExpande(0) }),
               case .highlightRangeExpande(let value) = highlightRangeExpandeStyle
            {
                self.enlarge = value
            } else {
                self.enlarge = 0
            }
            
            if let timeoutStyle = styles.first(where: { $0 == .timeout(0) }),
               case .timeout(let value) = timeoutStyle
            {
                self.timeout = value
            } else {
                self.timeout = Marker.default.timeout
            }
            
            if let cornerStyle = styles.first(where: { $0 == .cornerStyle(.marker) }),
               case .cornerStyle(let style) = cornerStyle
            {
                self.style = style
            } else {
                self.style = Marker.default.style
            }
            
            self.isDecoration = options.contains(.decoration)
            self.isStrongGuidance = options.contains(.strongGuidance)
            self.isEventPenetration = options.contains(.eventPenetration)
            
            if self.isDecoration {
                self.dimFrame = .zero
            }
            
            self.completion = completion
        }
    }
}

