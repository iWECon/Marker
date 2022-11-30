//
//  Created by i on 2022/11/30.
//

import UIKit

// Internal used

// MARK: setup
extension Marker {
    
    internal func setupTimeoutIfNeeded() {
        guard current.timeout > 0 else {
            // skip when timeout is 0, bcz 0 means forever
            return
        }
        
        let identifier = current.identifier
        let timeout = Marker.default.timeoutAfterAnimateDidCompletion ? (current.timeout + animateDuration) : current.timeout
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + timeout) { [weak self] in
            guard self?.animateMaps[identifier] == false else {
                // whether it has been manually skipped
                return
            }
            self?.showNext(triggerByUser: false)
        }
    }
    
    internal func setupIntro(calculate: Calculate) {
        if let introString = current.intro as? String {
            contentLabel.text = introString
        } else if let attributedString = current.intro as? NSAttributedString {
            contentLabel.attributedText = attributedString
        } else {
            contentLabel.text = "Can not support this type: \(type(of: current.intro))"
        }
        contentLabel.frame.size = calculate.calculateContentSize(label: contentLabel)
    }
    
    internal func setupDimmingView(calculate: Calculate) {
        dimmingView.frame = bounds
        let dimmingPath = calculate.dimmingViewMaskPath
        
        if maskLayer.superlayer == nil || dimmingViewShouldTransition {
            maskLayer.path = dimmingPath.cgPath
            maskLayer.backgroundColor = UIColor.black.cgColor
            dimmingView.layer.mask = maskLayer
            UIView.animate(withDuration: animateDuration) {
                self.dimmingView.alpha = 1
            }
        } else {
            if current.dimFrame == .zero {
                UIView.animate(withDuration: animateDuration) {
                    self.dimmingView.alpha = 0
                }
            } else if dimmingView.alpha != 1 {
                maskLayer.path = dimmingPath.cgPath
                UIView.animate(withDuration: animateDuration) {
                    self.dimmingView.alpha = 1
                }
            } else {
                pathAnimate(from: maskLayer, to: dimmingPath)
            }
        }
    }
}

// First call the above method(setup) and then Call the following method.

extension Marker {
    
    internal func calculateGradientRange(calculate: Calculate) -> CGRect {
        let padding = Marker.default.padding
        let contentSize = contentLabel.frame.size
        let bumpHeight: CGFloat = calculate.info.isArrowHidden ? 0 : 6
        let highlightRangeRect: CGRect = calculate.highlightRangeRect
        
        var gradientRect: CGRect = .zero
        // MARK: size
        gradientRect.size = CGSize(
            width: contentSize.width + padding.left + padding.right,
            height: contentSize.height + padding.top + padding.bottom + bumpHeight
        )
        
        // MARK: origin.x
        switch calculate.info.hAlignment {
        case .center:
            // origin.midX = highlightRect.midX
            gradientRect.origin.x = highlightRangeRect.midX - (gradientRect.width / 2)
            
        case .left:
            // origin.x = highlightRect.minX
            gradientRect.origin.x = highlightRangeRect.minX
            
        case .right:
            // origin.maxX = highlightRect.maxX
            gradientRect.origin.x = highlightRangeRect.maxX - gradientRect.width
        }
        
        // MARK: check and fix origin.x
        if gradientRect.minX < 10 { // horizontally safe area
            gradientRect.origin.x = 10
        }
        if gradientRect.maxX > calculate.safetyRangeSize.width {
            gradientRect.origin.x = calculate.safetyRangeSize.width - gradientRect.width
        }
        
        // MARK: origin.y
        let topOriginY: CGFloat = highlightRangeRect.minY - Marker.default.spacing - gradientRect.height - bumpHeight
        let bottomOriginY: CGFloat = highlightRangeRect.maxY + Marker.default.spacing + bumpHeight
        switch calculate.info.vAlignment {
        case .auto, .top:
            gradientRect.origin.y = topOriginY
            
        case .bottom:
            gradientRect.origin.y = bottomOriginY
        }
        
        // MARK: check and fix origin.y
        let gradientRectAtWindow = self.convert(gradientRect, to: nil)
        if gradientRectAtWindow.minY < 120 {
            // display on dynamic island or notch
            // switch to `.bottom`
            gradientRect.origin.y = bottomOriginY
        }
        if gradientRectAtWindow.maxY > UIScreen.main.bounds.height - 34 {
            // display outside the safe area
            // switch to `.top`
            gradientRect.origin.y = topOriginY
        }
        return gradientRect
    }
}
