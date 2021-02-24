//
//  Factory.swift
//  Marker
//
//  Created by iWw on 2021/2/24.
//

import UIKit

// MARK:- Helper
extension Marker {
    
    var markerInnerFrame: CGRect {
        if current.isMarkerValidate {
            return current.markerSuperview.convert(current.markerView.frame, to: self)
        }
        return .zero
    }
    
    var isDimmingViewShouldTransition: Bool {
        var shouldAnimate = false
        if let path = maskLayer.path, UIBezierPath(cgPath: path).bounds == .zero {
            shouldAnimate = true
        }
        return shouldAnimate
    }
}

// MARK:- Set timeout
extension Marker {
    
    func setTimeout() {
        guard current.timeout > 0 else {
            return
        }
        
        let identifier = current.identifier
        let timeout = Marker.default.timeoutAfterAnimateDidCompletion ? (Double(current.timeout) + animateDuration) : Double(current.timeout)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            guard self?.animateMaps[identifier] == false else { return }
            self?.showNext(triggerByUser: false)
        }
    }
}

// MARK:- Set Mask Layer
extension Marker {
    func setMaskLayer() {
        dimmingView.frame = bounds
        
        let markerFrame = current.dimFrame == .zero ? .zero : markerInnerFrame.insetBy(dx: -current.enlarge, dy: -current.enlarge)
        
        guard current.isMarkerValidate else {
            let isPreviousValidate = previous?.isMarkerValidate ?? false
            var previousMarkerFrame: CGRect
            if isPreviousValidate {
                previousMarkerFrame = previous!.markerSuperview.convert(previous!.markerView.frame, to: self)
                previousMarkerFrame.origin = .init(x: previousMarkerFrame.origin.x + (previousMarkerFrame.width / 2), y: previousMarkerFrame.origin.y + (previousMarkerFrame.height / 2))
                previousMarkerFrame.size = .zero
            } else {
                // center of screen
                previousMarkerFrame = .init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            }
            
            configureDimmingView(cornerRadius: 0, markerFrame: previousMarkerFrame, dimFrame: UIScreen.main.bounds)
            return
        }
        
        let cornerRadius: CGFloat
        switch current.style {
        case .marker:
            let isRounded = current.markerView.layer.cornerRadius == markerInnerFrame.height / 2
            cornerRadius = isRounded ? markerFrame.height / 2 : current.markerView.layer.cornerRadius
        case .square:
            cornerRadius = 0
        case .round:
            cornerRadius = markerFrame.height / 2
        case .radius(let radius):
            cornerRadius = radius
        }
        
        configureDimmingView(cornerRadius: cornerRadius, markerFrame: markerFrame, dimFrame: current.dimFrame)
    }
    
    private func configureDimmingView(cornerRadius: CGFloat, markerFrame: CGRect, dimFrame: CGRect) {
        let markerPath = UIBezierPath(roundedRect: markerFrame, cornerRadius: cornerRadius).reversing()
        
        // set dimming path
        let dimmingPath = UIBezierPath(roundedRect: current.dimFrame, cornerRadius: 0)
        dimmingPath.append(markerPath)
        
        if maskLayer.superlayer == nil || isDimmingViewShouldTransition {
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

// MARK:- Path animate
extension Marker {
    func pathAnimate(from: CAShapeLayer, to: UIBezierPath) {
        from.removeAnimation(forKey: "_pathAnimate")
        
        let animate = CABasicAnimation(keyPath: "path")
        animate.fromValue = from.path
        animate.toValue = to.cgPath
        animate.duration = animateDuration
        animate.timingFunction = CAMediaTimingFunction(name: .easeOut)
        from.add(animate, forKey: "_pathAnimate")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        from.path = to.cgPath
        CATransaction.commit()
    }
}


// MARK:- Set Content and calculator content size
extension Marker {
    
    @discardableResult
    func makeContent() -> CGSize {
        let contentSize = makeTextContentIfNeeded() ?? makeImageContentIfNeeded() ?? .zero
        return contentSize
    }
    
    func makeTextContentIfNeeded() -> CGSize? {
        guard let textIntro = current.intro as? Info.Text, textIntro.isValidate else { return nil }
        
        // set text intro
        if let stringIntro = textIntro.intro {
            contentLabel.attributedText = nil // clear attributed text
            contentLabel.text = stringIntro
        } else if let attributedStringIntro = textIntro.attributedIntro {
            contentLabel.text = nil // clear text
            contentLabel.attributedText = attributedStringIntro
        }
        
        let maxWidth = min(UIScreen.main.bounds.width - 20,
                           current.maxWidth)
        let contentSize = contentLabel.sizeThatFits(.init(width: maxWidth - Self.default.padding.left - Self.default.padding.right, height: .greatestFiniteMagnitude))
        
        contentLabel.frame.size = contentSize
        return contentSize
    }
    
    func makeImageContentIfNeeded() -> CGSize? {
        guard let intro = current.intro as? Info.Image, intro.isValidate, let view = intro.image else { return nil }
        return intro.size ?? view.size
    }
}
