//
//  Created by iWw on 2021/1/15.
//

import UIKit

public class Marker: UIView {
    
    // MARK: Static properties
    private static var markerInstances = NSMapTable<NSString, Marker>.strongToWeakObjects()
    
    // MARK: Public properties
    public typealias CompletionBlock = (_: Marker, _ isTriggerByUser: Bool) -> Void
    
    /// Global appearence settings. More detail see `Marker+Appearence.swift`.
    public static var `default` = Marker.Appearence()
    
    public var identifier: String?
    
    public var animateDuration: TimeInterval = 0.34
    
    // MARK: Internal properties
    weak var onView: UIView?
    
    // Datas
    var current: Info!
    var nexts: [Info] = []
    var animateMaps: [String: Bool] = [:]
    var completion: CompletionBlock?
    var lastVAlignment: Info.VAlignment = .auto
    
    // Views
    let dimmingView = UIView()
    let contentView = UIView()
    let contentLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    let bumpLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    // MARK: - Initialize
    public required init(_ info: Info, identifier: String? = nil) {
        self.identifier = identifier
        self.current = info
        super.init(frame: .zero)
        self.animateMaps[info.identifier] = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func installViews() {
        contentLabel.font = current.font
        contentLabel.textColor = current.textColor
        contentLabel.numberOfLines = 0
        
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        gradientLayer.anchorPoint = .zero
        gradientLayer.colors = current.backgroundColor.colors
        gradientLayer.startPoint = current.backgroundColor.startPoint
        gradientLayer.endPoint = current.backgroundColor.endPoint
        if let locations = current.backgroundColor.locations {
            gradientLayer.locations = locations
        }
        
        addSubview(dimmingView)
        addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        onView?.addSubview(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNextTriggerByUser))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    // MARK: Show next tap gesture Action
    @objc private func showNextTriggerByUser(tap: UITapGestureRecognizer) {
        guard !current.isDecoration else { // is not decoration
            return
        }
        
        // and is not event penetration
        if current.isStrongGuidance, current.isEventPenetration {
            return
        }
        
        if current.isStrongGuidance,
           let markView = current.marker,
           let markSuperview = markView.superview
        {
            let tapPoint = tap.location(in: self)
            if !markSuperview.convert(markView.frame, to: self).contains(tapPoint) {
                return
            }
        }
        showNext(triggerByUser: true)
    }
    
    var dimmingViewShouldTransition: Bool {
        var shouldAnimate = false
        if let path = maskLayer.path, UIBezierPath(cgPath: path).bounds == .zero {
            shouldAnimate = true
        }
        return shouldAnimate
    }
    
    // MARK: Layout
    func layout(triggerByUser: Bool) {
        
        guard let calculate = Calculate(info: current, onView: self) else {
            showNext(triggerByUser: triggerByUser)
            return
        }
        
        self.setupTimeoutIfNeeded()
        self.setupDimmingView(calculate: calculate)
        
        self.setupIntro(calculate: calculate)
        
        let (gradientFrame, vAlignment) = self.calculateGradientRange(calculate: calculate)
        self.gradientLayer.bounds = CGRect(origin: .zero, size: gradientFrame.size)
        if contentView.frame == .zero {
            contentView.alpha = 0
            contentView.frame = gradientFrame
            contentView.transform = CGAffineTransform(
                translationX: 0,
                y: vAlignment == .top ? (current.spacing) : (-current.spacing)
            )
                .concatenating(CGAffineTransform(scaleX: 0.98, y: 0.98))
            
            UIView.animate(withDuration: animateDuration) {
                self.contentView.alpha = 1
                self.contentView.transform = .identity
            }
        } else {
            contentView.frame = gradientFrame
        }
        
        let (arrowBezierPath, labelOrigin) = self.triangleArrowBezierPath(
            calculate: calculate,
            gradientFrame: gradientFrame,
            vAlignment: vAlignment
        )
        self.lastVAlignment = vAlignment
        contentLabel.frame.origin = labelOrigin
        
        if gradientLayer.mask == nil {
            bumpLayer.path = arrowBezierPath.cgPath
            bumpLayer.backgroundColor = UIColor.black.cgColor
            gradientLayer.mask = bumpLayer
        } else {
            pathAnimate(from: bumpLayer, to: arrowBezierPath)
        }
    }
    
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
    
    // MARK: Show next
    @objc public func showNext(triggerByUser: Bool) {
        // show next or dimiss
        animateMaps[current.identifier] = true
        if current.dimFrame == .zero {
            dimmingView.alpha = 0
        }
        
        current.completion?(self, triggerByUser)
        current.completion = nil // release
        guard let next = nexts.first else {
            // dimiss
            dismiss(triggerByUser: triggerByUser)
            return
        }
        self.current = next
        nexts.removeFirst()
        
        UIView.animate(withDuration: animateDuration, delay: 0, options: [.allowUserInteraction]) {
            self.layout(triggerByUser: triggerByUser)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // decoration not respond any event
        if current.isDecoration {
            return nil
        }
        
        // eventPenetration and strongGuidance
        // means: only respond on tap the highlight range.
        if current.isStrongGuidance, current.isEventPenetration,
           let markView = current.marker, let markSuperview = markView.superview
        {
            let innertFrame = markSuperview.convert(markView.frame, to: self)
            let highlightFrame = innertFrame.insetBy(dx: -current.enlarge, dy: -current.enlarge)
            
            if highlightFrame.contains(point) {
                return current.marker?.hitTest(point, with: event) ?? current.marker
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: Actions
public extension Marker {
    
    @discardableResult func next(_ info: Info) -> Marker {
        nexts.append(info)
        animateMaps[info.identifier] = false
        return self
    }
    
    @discardableResult func nexts(_ infos: [Info]) -> Marker {
        nexts.append(contentsOf: infos)
        infos.forEach({ animateMaps[$0.identifier] = false })
        return self
    }
    
    func dismiss(triggerByUser: Bool = true) {
        Self.removeInstance(self)
        
        let translationY: CGFloat = self.lastVAlignment == .bottom ? (-current.spacing) : (current.spacing)
        
        UIView.animate(withDuration: animateDuration) {
            self.dimmingView.alpha = 0
            
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: translationY)
                .concatenating(CGAffineTransform(scaleX: 0.98, y: 0.98))
        } completion: { (_) in
            self.completion?(self, triggerByUser)
            self.completion = nil
            self.removeFromSuperview()
        }
    }
    
    func show(on onView: UIView, completion: CompletionBlock? = nil) {
        Self.markerInstances.setObject(self, forKey: (identifier ?? current.identifier) as NSString)
        
        if self.frame == .zero {
            self.frame = onView.bounds
        }
        self.onView = onView
        self.completion = completion
        installViews()
        layout(triggerByUser: true)
    }
    
}


// MARK: Static functions
public extension Marker {
    /// Dismiss all marker anywhere
    static func dismiss(triggerByUser: Bool = true) {
        for (_, instance) in markerInstances.dictionaryRepresentation() {
            instance.dismiss(triggerByUser: triggerByUser)
        }
    }
    
    /// Instance marker with identifier
    static func instance(from identifier: String) -> Marker? {
        markerInstances.object(forKey: identifier as NSString)
    }
    
    /// Remove instance
    static func removeInstance(_ marker: Marker) {
        markerInstances.removeObject(forKey: marker.identifier as? NSString)
    }
}
