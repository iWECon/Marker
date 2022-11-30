//
//  Marker.swift
//  vietnam
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
        
        guard let markView = current.marker, let markSuperView = current.marker?.superview else {
            showNext(triggerByUser: triggerByUser)
            return
        }
        
        if current.timeout > 0 { // enable timeout if set timeout
            let identifier = current.identifier
            let timeout = Marker.default.timeoutAfterAnimateDidCompletion ? (Double(current.timeout) + animateDuration) : Double(current.timeout)
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
                // whether it has been manually skipped
                guard self?.animateMaps[identifier] == false else { return }
                self?.showNext(triggerByUser: false)
            }
        }
        
        dimmingView.frame = bounds
        
        let spacing = Self.default.spacing
        let innerFrame = markSuperView.convert(markView.frame, to: self)
        let isRound = markView.layer.cornerRadius == innerFrame.height / 2
        let markerFrame = current.dimFrame == .zero ? .zero : innerFrame.insetBy(dx: -current.enlarge, dy: -current.enlarge)
        let withoutDimframe = innerFrame.insetBy(dx: -current.enlarge, dy: -current.enlarge)
        
        // set cornerRadiu
        let cornerRadius: CGFloat
        switch current.style {
        case .marker:
            cornerRadius = isRound ? markerFrame.height / 2 : markView.layer.cornerRadius
        case .square:
            cornerRadius = 0
        case .round:
            cornerRadius = markerFrame.height / 2
        case .radius(let radius):
            cornerRadius = radius
        }
        
        let markerPath = UIBezierPath(roundedRect: markerFrame, cornerRadius: cornerRadius).reversing()
        
        // set dimming path
        let dimmingPath = UIBezierPath(roundedRect: current.dimFrame, cornerRadius: 0)
        dimmingPath.append(markerPath)
        
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
        
        if let introString = current.intro as? String {
            contentLabel.text = introString
        } else if let attributedString = current.intro as? NSAttributedString {
            contentLabel.attributedText = attributedString
        } else {
            contentLabel.text = "Can not support this type: \(type(of: current.intro))"
        }
        
        // reload contentLabel size
        let padding = Self.default.padding
        let maxWidth = min(UIScreen.main.bounds.width - 20,
                           current.maxWidth)
        let contentSize = contentLabel.sizeThatFits(.init(width: maxWidth - padding.left - padding.right, height: .greatestFiniteMagnitude))
        contentLabel.frame.size = contentSize
        
        // calculator gradient frame
        let bumpHeight: CGFloat = current.isArrowHidden ? 0 : 6
        // 如果视图在中心线右边，则三角形也在右边, 否则在左边
        let isRight = innerFrame.minX >= (frame.width / 2)
        
        var gradientFrame: CGRect = .zero
        gradientFrame.size = .init(width: contentSize.width + padding.left + padding.right,
                                   height: contentSize.height + padding.top + padding.bottom + bumpHeight)
        
        // 三角形起点偏移量
        var bumpOffsetX: CGFloat = 0
        
        if isRight {
            // right
            gradientFrame.origin.x = innerFrame.maxX - gradientFrame.width
            if gradientFrame.origin.x < 10 {
                bumpOffsetX = -gradientFrame.origin.x + 10
                gradientFrame.origin.x = 10
            }
        } else {
            // left
            gradientFrame.origin.x = innerFrame.minX
            if gradientFrame.maxX > UIScreen.main.bounds.width - 10 { // 右边超出右边
                bumpOffsetX = gradientFrame.minX - (UIScreen.main.bounds.width - gradientFrame.width - 10)
                gradientFrame.origin.x = UIScreen.main.bounds.width - gradientFrame.width - 10
            } else if gradientFrame.minX < 10 {
                gradientFrame.origin.x = 10
            }
        }
        
        let isBottom = innerFrame.maxY >= frame.height / 2
        if isBottom {
            // bottom
            gradientFrame.origin.y = innerFrame.minY - gradientFrame.height - spacing - current.enlarge
        } else {
            // top
            gradientFrame.origin.y = innerFrame.maxY + spacing + current.enlarge
        }
        gradientLayer.bounds = .init(x: 0, y: 0, width: gradientFrame.width, height: gradientFrame.height)
        
        if contentView.frame == .zero {
            contentView.alpha = 0
            contentView.frame = gradientFrame
            contentView.transform = .init(translationX: 0, y: isBottom ? -30 : 30)
            UIView.animate(withDuration: animateDuration) {
                self.contentView.alpha = 1
                self.contentView.transform = .identity
            }
        } else {
            contentView.frame = gradientFrame
        }
        
        // make mask
        var rectY: CGFloat = bumpHeight
        
        var labelOriginY: CGFloat = bumpHeight + padding.top
        let bezierPath = UIBezierPath()
        if !current.isArrowHidden {
            // draw triangle
            switch current.trianglePosition {
            case .auto:
                if isRight, !isBottom { // top, right
                    //labelOriginY
                    let startPoint = CGPoint(x: gradientFrame.width - 15 - bumpOffsetX, y: bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                } else if isRight, isBottom { // bottom, right
                    rectY = 0
                    labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                    
                    let startPoint = CGPoint(x: gradientFrame.width - 15 - bumpOffsetX, y: gradientFrame.height - bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                } else if !isRight, isBottom { // bottom, left
                    rectY = 0
                    labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                    
                    let startPoint = CGPoint(x: 15 + bumpOffsetX, y: gradientFrame.height - bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x + 6, y: gradientFrame.height))
                    bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
                    
                } else if !isRight, !isBottom { // top, left
                    let startPoint = CGPoint(x: 15 + bumpOffsetX, y: bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x + 6, y: 0))
                    bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
                }
                
            case .left(let offset):
                let minX = min(gradientFrame.minX, withoutDimframe.minX)
                if isBottom {
                    // triangle on bottom-left
                    rectY = 0
                    labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                    
                    let startPoint = CGPoint(x: minX + 10 + offset, y: gradientFrame.height - bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x + 6, y: gradientFrame.height))
                    bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
                } else {
                    // triangle on top-left
                    let startPoint = CGPoint(x: minX + 10 + offset, y: bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x + 6, y: 0))
                    bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
                }
                break
            case .center(let offset):
                //let width = min(gradientFrame.width, withoutDimframe.width)
                let width = self.convert(withoutDimframe, to: contentView).midX
                if isBottom {
                    // triangle on bottom-center
                    rectY = 0
                    labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                    
                    let startPoint = CGPoint(x: width + 6 + offset, y: gradientFrame.height - bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                } else {
                    // triangle on top-center
                    let startPoint = CGPoint(x: width + 6 + offset, y: bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                }
                
            case .right(let offset):
                let width = min(gradientFrame.width, withoutDimframe.width)
                if isBottom {
                    // triangle on bottom-right
                    rectY = 0
                    labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                    
                    let startPoint = CGPoint(x: width - 10 + offset, y: gradientFrame.height - bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                } else {
                    // triangle on top-right
                    let startPoint = CGPoint(x: width - 10 + offset, y: bumpHeight)
                    bezierPath.move(to: startPoint)
                    bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
                    bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                }
            }
        }
        bezierPath.append(.init(roundedRect: .init(x: 0, y: rectY, width: gradientLayer.frame.width, height: gradientLayer.frame.height - bumpHeight), cornerRadius: 6))
        
        contentLabel.frame.origin.x = padding.left
        contentLabel.frame.origin.y = labelOriginY
        
        if gradientLayer.mask == nil {
            bumpLayer.path = bezierPath.cgPath
            bumpLayer.backgroundColor = UIColor.black.cgColor
            gradientLayer.mask = bumpLayer
        } else {
            pathAnimate(from: bumpLayer, to: bezierPath)
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
        
        UIView.animate(withDuration: animateDuration) {
            self.dimmingView.alpha = 0
            
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 50).concatenating(CGAffineTransform(scaleX: 1.1, y: 1.1))
        } completion: { [weak self] (_) in
            guard let self = self else { return }
            self.completion?(self, triggerByUser)
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
