//
//  Marker.swift
//  vietnam
//
//  Created by iWw on 2021/1/15.
//

import UIKit

public class Marker: UIView {
    
    // MARK:- Static properties
    private static var markerInstances: Set<Marker> = []
    public static func dismiss() {
        markerInstances.forEach({ $0.dismiss(triggerByUser: true) })
    }
    
    // MARK:- Public properties
    public typealias CompletionBlock = (_: Marker, _ isTriggerByUser: Bool) -> Void
    
    public static var `default` = Marker.Appearence()
    public var animateDuration: TimeInterval = 0.34
    
    // MARK:- Internal properties
    weak var onView: UIView?
    
    var current: Info
    var previous: Info?
    
    var nexts: [Info] = []
    
    var animateMaps: [String: Bool] = [:]
    
    /// completion，所有任务完成后的 completion
    var completion: CompletionBlock?
    
    required public init(_ info: Info) {
        self.current = info
        super.init(frame: .zero)
        self.animateMaps[info.identifier] = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 下一个
    @discardableResult
    public func next(_ info: Info) -> Marker {
        nexts.append(info)
        animateMaps[info.identifier] = false
        return self
    }
    
    let dimmingView = UIView()
    let contentView = UIView()
    let contentLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    let bumpLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    func installViews() {
        
        contentLabel.font = Self.default.textFont
        contentLabel.textColor = Self.default.textColor
        contentLabel.numberOfLines = 0
        
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        gradientLayer.anchorPoint = .zero
        gradientLayer.colors = Self.default.colors
        gradientLayer.startPoint = Self.default.colorStartPoint
        gradientLayer.endPoint = Self.default.colorEndPoint
        if let locations = Self.default.colorLocations {
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
    
    @objc func showNextTriggerByUser(tap: UITapGestureRecognizer) {
        if current.isOnlyAcceptHighlightRange { // bugfix: 将 point(inside:with) 替换为这里的逻辑, 处理点击底部视图可响应事件的 view 时依然会响应的问题
            let tapPoint = tap.location(in: self)
            if !markerInnerFrame.contains(tapPoint) {
                return
            }
        }
        showNext(triggerByUser: true)
    }
    
    func layout(triggerByUser: Bool) {
        setTimeout()
        setMaskLayer()
        
        // make content
        let contentSize = makeContent()
        
        let (gradientFrame, edge) = setGradientBackground(contentSize: contentSize)
        setContentView(gradientFrame: gradientFrame, edge: edge)
        
        let padding = Self.default.padding
        
        // calculator gradient frame
        let bumpHeight: CGFloat = current.isShowArrow ? 6 : 0
        
        // make mask
        var rectY: CGFloat = bumpHeight
        let bumpOffsetX: CGFloat = 10
        
        var labelOriginY: CGFloat = bumpHeight + padding.top
        let bezierPath = UIBezierPath()
        if current.isShowArrow {
            switch edge {
            case .topRight:
                let startPoint = CGPoint(x: gradientFrame.width - 15 - bumpOffsetX, y: bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
                bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
            case .bottomRight:
                rectY = 0
                labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                
                let startPoint = CGPoint(x: gradientFrame.width - 15 - bumpOffsetX, y: gradientFrame.height - bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
                bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
                
            case .bottomLeft:
                rectY = 0
                labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
                
                let startPoint = CGPoint(x: 15 + bumpOffsetX, y: gradientFrame.height - bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x + 6, y: gradientFrame.height))
                bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
                
            case .topLeft:
                let startPoint = CGPoint(x: 15 + bumpOffsetX, y: bumpHeight)
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: .init(x: startPoint.x + 6, y: 0))
                bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
            case .center:
                break
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
    
    @objc func showNext(triggerByUser: Bool) {
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
        
        // clear other custom view (UIImageView or UIView)
        contentView.subviews.filter({ $0 != contentLabel }).forEach({ $0.removeFromSuperview() })
        
        self.previous = current
        self.current = next
        nexts.removeFirst()
        
        UIView.animate(withDuration: animateDuration, delay: 0, options: [.allowUserInteraction]) {
            self.layout(triggerByUser: triggerByUser)
        }
    }
    
}

public extension Marker {
    
    func dismiss(triggerByUser: Bool) {
        Self.markerInstances.remove(self)
        UIView.animate(withDuration: 0.34) {
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
        Self.markerInstances.insert(self)
        if self.frame == .zero {
            self.frame = onView.frame
        }
        self.onView = onView
        self.completion = completion
        installViews()
        layout(triggerByUser: true)
    }
    
}
