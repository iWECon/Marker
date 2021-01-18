//
//  Marker.swift
//  vietnam
//
//  Created by iWw on 2021/1/15.
//

import UIKit

public class Marker: UIView {
    
    // MARK:- Public properties
    public typealias CompletionBlock = () -> Void
    
    public struct Appearence {
        public var colors: [CGColor] = [
            UIColor(red: 255 / 255, green: 200 / 255, blue: 0, alpha: 1).cgColor,
            UIColor(red: 255 / 255, green: 51 / 255, blue: 131 / 255, alpha: 1).cgColor
        ]
        
        public var colorStartPoint: CGPoint = .init(x: 0, y: 0.5)
        public var colorEndPoint: CGPoint = .init(x: 1, y: 0.5)
        public var padding: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        public var spacing: CGFloat = 10
    }
    public static var `default` = Appearence()
    
    public var animateDuration: TimeInterval = 0.34
    
    // MARK:- Internal properties
    public struct Info {
        public enum Style {
            /// default
            case square
            case round
            case radius(_ radius: CGFloat)
        }
        
        public weak var marker: UIView?
        public var intro: String
        public var maxWidth: CGFloat
        public var dimFrame: CGRect = UIScreen.main.bounds
        public var style: Style = .square
        public var timeout: TimeInterval = 0
        public var completion: CompletionBlock?
        
        var identifier: String {
            "\(marker?.description ?? "")-\(intro)-\(dimFrame)-\(timeout)-\(style)"
        }
        
        public init(marker: UIView?, intro: String, maxWidth: CGFloat = 240, dimFrame: CGRect = UIScreen.main.bounds, style: Info.Style = .square, timeout: TimeInterval = 0, completion: CompletionBlock? = nil) {
            self.marker = marker
            self.intro = intro
            self.maxWidth = maxWidth
            self.dimFrame = dimFrame
            self.style = style
            self.timeout = timeout
            self.completion = completion
        }
    }
    
    weak var onView: UIView?
    var current: Info
    var nexts: [Info] = []
    var animateMaps: [String: Bool] = [:]
    
    /// completion，所有任务完成后的 completion
    var completion: CompletionBlock?
    
    required public init(_ info: Info, on onView: UIView) {
        self.current = info
        super.init(frame: onView.bounds)
        self.animateMaps[info.identifier] = false
        self.onView = onView
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 下一个
    public func next(_ info: Info) -> Marker {
        nexts.append(info)
        animateMaps[info.identifier] = false
        return self
    }
    
    let dimmingView = UIView()
    let contentView = UIView()
    public let contentLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    let bumpLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    func installViews() {
        
        contentLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        gradientLayer.anchorPoint = .zero
        gradientLayer.colors = Self.default.colors
        gradientLayer.startPoint = Self.default.colorStartPoint
        gradientLayer.endPoint = Self.default.colorEndPoint
        
        addSubview(dimmingView)
        addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        onView?.addSubview(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNext))
        addGestureRecognizer(tap)
    }
    
    func layout() {
        guard let markView = current.marker, let markSuperView = current.marker?.superview else {
            // 没有找到 marker 或者 marker 没有添加到视图上，直接进入下一个
            showNext()
            return
        }
        
        if current.timeout > 0 { // 如果有超时时间，则开启超时
            let identifier = current.identifier
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(current.timeout) + animateDuration)) { [weak self] in
                // 超时后判断
                guard self?.animateMaps[identifier] == false else { return }
                self?.showNext()
            }
        }
        
        dimmingView.frame = bounds
        
        let spacing = Self.default.spacing
        let innerFrame = markSuperView.convert(markView.frame, to: self)
        
        // set cornerRadiu
        let cornerRadius: CGFloat
        switch current.style {
        case .square:
            cornerRadius = 0
        case .round:
            cornerRadius = markView.frame.height / 2
        case .radius(let radius):
            cornerRadius = radius
        }
        let markPath = UIBezierPath(roundedRect: innerFrame, cornerRadius: cornerRadius).reversing()
        
        // set dimming path
        let dimmingPath = UIBezierPath(roundedRect: current.dimFrame, cornerRadius: 0)
        dimmingPath.append(markPath)
        
        if maskLayer.superlayer == nil {
            maskLayer.path = dimmingPath.cgPath
            maskLayer.backgroundColor = UIColor.black.cgColor
            dimmingView.layer.mask = maskLayer
            UIView.animate(withDuration: animateDuration) {
                self.dimmingView.alpha = 1
            }
        } else {
            pathAnimate(from: maskLayer, to: dimmingPath)
        }
        
        contentLabel.text = current.intro
        let contentSize = contentLabel.sizeThatFits(.init(width: current.maxWidth, height: .greatestFiniteMagnitude))
        contentLabel.frame.size = contentSize
        
        // calculator gradient frame
        let padding = Self.default.padding
        let bumpHeight: CGFloat = 6
        // innerFrame centerX
        let centerX = (innerFrame.minX + innerFrame.maxX) / 2
        // 是否在中心线右边, 如果视图在中心线右边，则三角形也在右边, 否则在左边
        let isRight = centerX >= (frame.width / 2)
        
        var gradientFrame: CGRect = .zero
        gradientFrame.size = .init(width: contentSize.width + padding.left + padding.right,
                                   height: contentSize.height + padding.top + padding.bottom + bumpHeight)
        
        if isRight {
            // right
            gradientFrame.origin.x = innerFrame.maxX - gradientFrame.width
            if gradientFrame.origin.x >= gradientFrame.maxX - 10 {
                gradientFrame.origin.x = gradientFrame.maxX - 10
            }
        } else {
            // left
            gradientFrame.origin.x = innerFrame.minX
            if gradientFrame.minX <= 10 {
                gradientFrame.origin.x = 10
            }
        }
        
        let centerY = (innerFrame.minY + innerFrame.maxY) / 2
        let isBottom = centerY >= frame.height / 2
        if isBottom {
            // bottom
            gradientFrame.origin.y = innerFrame.minY - gradientFrame.height - spacing
        } else {
            // top
            gradientFrame.origin.y = innerFrame.maxY + spacing
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
        if isRight, !isBottom { // top, right
            //labelOriginY
            let startPoint = CGPoint(x: gradientFrame.width - 15, y: bumpHeight)
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: .init(x: startPoint.x - 6, y: 0))
            bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
        } else if isRight, isBottom { // bottom, right
            rectY = 0
            labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
            
            let startPoint = CGPoint(x: gradientFrame.width - 15, y: gradientFrame.height - bumpHeight)
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: .init(x: startPoint.x - 6, y: gradientFrame.height))
            bezierPath.addLine(to: .init(x: startPoint.x - 12, y: startPoint.y))
        } else if !isRight, isBottom { // bottom, left
            rectY = 0
            labelOriginY = gradientFrame.height - bumpHeight - padding.bottom - contentLabel.frame.height
            
            let startPoint = CGPoint(x: 15, y: gradientFrame.height - bumpHeight)
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: .init(x: startPoint.x + 6, y: gradientFrame.height))
            bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
            
        } else if !isRight, !isBottom { // top, left
            let startPoint = CGPoint(x: 15, y: bumpHeight)
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: .init(x: startPoint.x + 6, y: 0))
            bezierPath.addLine(to: .init(x: startPoint.x + 12, y: startPoint.y))
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
    
    @objc func showNext() {
        // show next or dimiss
        animateMaps[current.identifier] = true
        
        current.completion?()
        guard let next = nexts.first else {
            // dimiss
            dismiss()
            return
        }
        
        self.current = next
        nexts.removeFirst()
        
        UIView.animate(withDuration: animateDuration) {
            self.layout()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.34) {
            self.dimmingView.alpha = 0
            
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 50).concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        } completion: { [weak self] (_) in
            self?.completion?()
            self?.removeFromSuperview()
        }
    }
    
    public func show(completion: CompletionBlock? = nil) {
        self.completion = completion
        installViews()
        layout()
    }
}
