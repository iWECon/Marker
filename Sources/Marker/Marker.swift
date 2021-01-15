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
    struct Info {
        weak var mark: UIView?
        var tips: String
        var maxWidth: CGFloat = 240
        var dimmingFrame: CGRect
        var completion: CompletionBlock?
    }
    var nexts: [Info] = []
    
    var current: Info
    weak var onView: UIView?
    
    /// completion，所有任务完成后的 completion
    var completion: CompletionBlock?
    
    
    // MARK:- init
    /// 初始化
    /// - Parameters:
    ///   - mark: 被标记的 view，确保是完全显示（至少是有完整的 frame）后使用
    ///   - tips: 引导提示
    ///   - on: 显示在某个 View 上
    ///   - dimmingFrame: 可选配置
    ///   - maxWidth: 引导提示的最大宽度，一般情况下不用调整
    ///   - completion: 单个引导完成后的回执，全部引导完成后的回执走 show(completion:) 设置
    required public init(mark: UIView, tips: String, on: UIView, dimmingFrame: CGRect = UIScreen.main.bounds, maxWidth: CGFloat = 240, completion: CompletionBlock? = nil) {
        self.current = Info(mark: mark, tips: tips, maxWidth: maxWidth, dimmingFrame: dimmingFrame, completion: completion)
        super.init(frame: on.bounds)
        
        self.onView = on
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 下一个
    /// - Parameters:
    ///   - mark: 被标记的 view，确保是完全显示（至少是有完整的 frame）后使用
    ///   - tips: 引导提示
    ///   - dimmingFrame: 可选需求，灰色背景的大小
    ///   - maxWidth: 引导提示的最大宽度，一般情况下不用调整
    ///   - completion: 引导完成时的 completion
    /// - Returns: Marker
    public func next(mark: UIView, tips: String, dimmingFrame: CGRect = UIScreen.main.bounds, maxWidth: CGFloat = 240, completion: CompletionBlock? = nil) -> Marker {
        nexts.append(.init(mark: mark, tips: tips, maxWidth: maxWidth, dimmingFrame: dimmingFrame, completion: completion))
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
        
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        addSubview(dimmingView)
        addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        onView?.addSubview(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNext))
        addGestureRecognizer(tap)
    }
    
    func layout() {
        guard let markView = current.mark, let markSuperView = current.mark?.superview else {
            showNext()
            return
        }
        dimmingView.frame = bounds
        
        let innerFrame = markSuperView.convert(markView.frame, to: self)
        
        let dimmingPath = UIBezierPath(roundedRect: current.dimmingFrame, cornerRadius: 0)
        let markPath = UIBezierPath(roundedRect: innerFrame, cornerRadius: markView.layer.cornerRadius).reversing()
        dimmingPath.append(markPath)
        
        if maskLayer.superlayer == nil {
            maskLayer.path = dimmingPath.cgPath
            maskLayer.backgroundColor = UIColor.black.cgColor
            dimmingView.layer.mask = maskLayer
        } else {
            pathAnimate(from: maskLayer, to: dimmingPath)
        }
        
        contentLabel.text = current.tips
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
            gradientFrame.origin.y = innerFrame.minY - gradientFrame.height - 10
        } else {
            // top
            gradientFrame.origin.y = innerFrame.maxY + 10
        }
        
        contentView.frame = gradientFrame
        gradientLayer.bounds = .init(x: 0, y: 0, width: gradientFrame.width, height: gradientFrame.height)
        gradientLayer.colors = Self.default.colors
        gradientLayer.startPoint = Self.default.colorStartPoint
        gradientLayer.endPoint = Self.default.colorEndPoint
        gradientLayer.anchorPoint = .zero
        
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
