//
//  Created by i on 2022/11/30.
//

import UIKit

// Internal
extension Marker {
    
    struct Calculate {
        typealias MarkerInfo = Marker.Info
        
        let info: MarkerInfo
        
        weak var marked: UIView!
        
        let spacing: CGFloat
        
        /// describe `marked` frame in self.
        let innerFrame: CGRect
        
        let highlightRangeRect: CGRect
        
        let isRound: Bool
        let markerFrame: CGRect
        let withoutDimFrame: CGRect
        
        let dimmingViewMaskPath: UIBezierPath
        
        let safetyRangeSize: CGSize
        
        init?(info: MarkerInfo, onView: Marker) {
            self.info = info
            
            guard let marked = info.marker,
                  let markedSuperview = marked.superview
            else {
                assert(false, "`marker` release or not added on view")
                return nil
            }
            
            self.spacing = Marker.default.spacing
            self.innerFrame = markedSuperview.convert(marked.frame, to: onView)
            self.isRound = marked.layer.cornerRadius == innerFrame.height / 2
            self.markerFrame = info.dimFrame == .zero ? .zero : innerFrame.insetBy(dx: -info.enlarge, dy: -info.enlarge)
            self.withoutDimFrame = self.innerFrame.insetBy(dx: -info.enlarge, dy: -info.enlarge)
            self.highlightRangeRect = self.markerFrame == .zero ? self.innerFrame : self.markerFrame
            
            // corner path reversing
            let cornerRadius: CGFloat
            switch info.style {
            case .marker:
                cornerRadius = self.isRound ? self.markerFrame.height / 2 : marked.layer.cornerRadius
            case .square:
                cornerRadius = 0
            case .round:
                cornerRadius = self.markerFrame.height / 2
            case .radius(let radius):
                cornerRadius = radius
            }
            let cornerReversingPath = UIBezierPath(roundedRect: self.markerFrame, cornerRadius: cornerRadius).reversing()
            let dimmingViewMaskPath = UIBezierPath(rect: info.dimFrame)
            dimmingViewMaskPath.append(cornerReversingPath)
            self.dimmingViewMaskPath = dimmingViewMaskPath
            
            self.safetyRangeSize = CGSize(width: onView.superview!.frame.width - 20, height: markedSuperview.frame.height)
        }
        
        func calculateContentSize(label: UILabel) -> CGSize {
            let padding = Marker.default.padding
            let maxWidth = max(10, min(UIScreen.main.bounds.width - 20, info.maxWidth) - padding.left - padding.right)
            var contentSize = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
            contentSize.width = ceil(contentSize.width)
            contentSize.height = ceil(contentSize.height)
            return contentSize
        }
    }
    
}
