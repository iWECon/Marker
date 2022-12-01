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
        // make content change has a fade effect
        contentLabel.layer.removeAnimation(forKey: "marker-fade-animation")
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = .fade
        transition.duration = animateDuration
        contentLabel.layer.add(transition, forKey: "marker-fade-animation")
        
        // change content
        if let introString = calculate.info.intro as? String {
            self.contentLabel.text = introString
        } else if let attributedString = calculate.info.intro as? NSAttributedString {
            self.contentLabel.attributedText = attributedString
        } else {
            self.contentLabel.text = "Can not support this type: \(type(of: calculate.info.intro))"
        }
        self.contentLabel.frame.size = calculate.calculateContentSize(label: self.contentLabel)
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
    
    internal func calculateGradientRange(calculate: Calculate) -> (gradientRect: CGRect, vAlignment: Info.VAlignment) {
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
        
        var resultVAlignment: Info.VAlignment = .auto
        switch calculate.info.vAlignment {
        case .auto:
            gradientRect.origin.y = topOriginY
            resultVAlignment = .top
            
            // MARK: check and fix origin.y
            let gradientRectAtWindow = self.convert(gradientRect, to: nil)
            if gradientRectAtWindow.minY < 120 {
                // display on dynamic island or notch
                // switch to `.bottom`
                gradientRect.origin.y = bottomOriginY
                resultVAlignment = .bottom
            }
            if gradientRectAtWindow.maxY > UIScreen.main.bounds.height - 34 {
                // display outside the safe area
                // switch to `.top`
                gradientRect.origin.y = topOriginY
                resultVAlignment = .top
            }
            
        case .top:
            // keep at top and not check available
            gradientRect.origin.y = topOriginY
            resultVAlignment = .top
            
        case .bottom:
            // keep at bottom and not check available
            gradientRect.origin.y = bottomOriginY
            resultVAlignment = .bottom
        }
        
        return (gradientRect, resultVAlignment)
    }
    
    internal func triangleArrowBezierPath(
        calculate: Calculate,
        gradientFrame: CGRect,
        vAlignment: Info.VAlignment
    ) -> (arrowBezierPath: UIBezierPath, labelOrigin: CGPoint) {
        let padding = Marker.default.padding
        let bumpHeight: CGFloat = calculate.info.isArrowHidden ? 0 : 6
        
        var rectY: CGFloat = bumpHeight
        var labelOrigin: CGPoint = CGPoint(x: padding.left, y: bumpHeight + padding.top)
        
        let bezierPath = UIBezierPath()
        if !calculate.info.isArrowHidden {
            let rect: CGRect = calculate.highlightRangeRect.width > gradientFrame.width ? gradientFrame : calculate.highlightRangeRect
            
            let width: CGFloat
            
            switch calculate.info.trianglePosition {
            case .auto:
                switch calculate.info.hAlignment {
                case .center:
                    width = self.convert(rect, to: contentView).midX
                case .left:
                    width = self.convert(rect, to: contentView).minX + 10 + (rect.width * 0.05)
                case .right:
                    width = self.convert(rect, to: contentView).maxX - 10 - (rect.width * 0.05)
                }
                
            case .left(let offset):
                width = self.convert(rect, to: contentView).minX + 10 + offset
                
            case .center(let offset):
                width = self.convert(rect, to: contentView).midX + offset
                
            case .right(let offset):
                width = self.convert(rect, to: contentView).maxX - 10 + offset
            }
            
            if vAlignment == .top {
                // triangle on bottom-center
                rectY = 0
                labelOrigin.y = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                
                let startPoint = CGPoint(x: width + 6, y: gradientFrame.height - bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
                bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
            } else {
                // triangle on top-center
                let startPoint = CGPoint(x: width + 6, y: bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
                bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
            }
        }
        bezierPath.append(
            UIBezierPath(
                roundedRect: CGRect(
                    x: 0, y: rectY,
                    width: gradientLayer.frame.width,
                    height: gradientLayer.frame.height - bumpHeight
                ),
                cornerRadius: 6
            )
        )
        return (bezierPath, labelOrigin)
    }
}
