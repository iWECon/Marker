//
//  ViewController.swift
//  Marker
//
//  Created by iWw on 2021/1/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var number2Button: UIButton!
    @IBOutlet weak var respondActionButton: UIButton!
    @IBOutlet weak var noMaskButton: UIButton!
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var followStyleButton: UIButton!
    
    @IBOutlet weak var subviewContainer: UIView!
    @IBOutlet weak var inSubviewButton: UIButton!
    
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet var bottomButtons: [UIButton]!
    
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var clickableInButton: UIButton!
    @IBOutlet weak var clickableOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        startButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        
        let buttons = [startButton, number2Button, respondActionButton, noMaskButton, roundButton, squareButton, followStyleButton, bottomButton, bottomButton] + bottomButtons
        for button in buttons {
            button?.backgroundColor = UIColor.secondarySystemGroupedBackground
            button?.layer.cornerRadius = 10
        }
        
        // 透传事件按钮添加事件
        respondActionButton.addTarget(self, action: #selector(respondAction(_:)), for: .touchUpInside)
        // 在子视图的按钮
        inSubviewButton.addTarget(self, action: #selector(tapInSubviewAction(_:)), for: .touchUpInside)
        // 底部的按钮
        bottomButton.addTarget(self, action: #selector(bottomAction(_:)), for: .touchUpInside)
        
        Marker(Marker.Info(marker: clickableInButton, intro: "这里是展示视图，需要手动 dismiss 才会消失。", options: [.decoration]))
            .show(on: pinView)
    }
    
    @objc func bottomAction(_ sender: UIButton) {
        let marker = Marker(.init(marker: bottomButton, intro: "Marker 引导，显示在控件上方"), identifier: "bottom")
        marker.next(.init(marker: bottomButtons[0], intro: "Marker: 支持三角箭头位置调整, 支持调整左/中/右, 且可调整偏移量, 本次显示为自动处理三角箭头位置"))
        marker.next(.init(marker: bottomButtons[1], intro: "本次三角箭头在左侧，且向右偏移（移动） 10px", styles: [.arrowPosition(.left(offset: 10))]))
        marker.next(.init(marker: bottomButtons[2], intro: "本次三角箭头在右侧，且向左偏移（移动） 10px", styles: [.arrowPosition(.right(offset: -10))]))
        marker.next(.init(marker: bottomButtons[3], intro: "本次三角箭头在中间，无偏移", styles: [.arrowPosition(.center(offset: 0))]))
        marker.next(.init(marker: bottomButtons[4], intro: "无"))
        marker.next(.init(marker: bottomButtons[5], intro: "无"))
        marker.show(on: self.view, completion: nil)
    }
    
    @objc func respondAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "透传事件", message: "你点击了透传按钮, 且按下`知道了`的时候会触发下一步引导", preferredStyle: .alert)
        alert.addAction(.init(title: "知道了", style: .cancel, handler: { _ in
            Marker.instance(from: "normal")?.showNext(triggerByUser: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapInSubviewAction(_ sender: UIButton) {
        //let info = Marker.Info(marker: inSubviewButton, intro: "显示在子视图里的 Marker", style: .radius(10), trianglePosition: .center(), enlarge: 4)
        let info = Marker.Info(marker: inSubviewButton, intro: "`Marker` display in subview",
                               styles: [
                                .arrowPosition(.center()),
                                .cornerStyle(.radius(10)),
                                .highlightRangeExpande(4)
                               ])
        Marker(info, identifier: "inSubview").show(on: subviewContainer, completion: nil)
    }
    
    @objc func topLeftAlert(sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "透传事件", preferredStyle: .alert)
        alert.addAction(.init(title: "确认", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        Marker.instance(from: "asdf")?.dismiss(triggerByUser: true)
    }
    
    @objc func tapAction(sender: UIButton) {
        // global configure. Use it in AppDelegate.swift(application.didFinishLaunchingWithOptions), if needed
        // 全局配置, 如果需要, 可以在应用启动时进行配置, 这里仅作为演示
        Marker.default.timeoutAfterAnimateDidCompletion = true
        Marker.default.timeout = 0
        
        let startInfo = Marker.Info(marker: startButton, intro: "起始按钮, 默认配置, 最大宽度 320, 点击任意处进入下一个", styles: [.arrowPosition(.left(offset: 0))])
        let number2Info = Marker.Info(marker: number2Button, intro: "第二个按钮, 默认配置", styles: [.arrowPosition(.right(offset: 0)), .hideArrow])
        let actionInfo = Marker.Info(marker: respondActionButton, intro: "第三个按钮, 可透传事件：仅点击高亮范围有效，且点击事，事件可以传递到按钮上（执行按钮的点击事件）并触发下一步事件", options: [.strongGuidance, .eventPenetration])
        let noMaskInfo = Marker.Info(marker: noMaskButton, intro: "第四个按钮, 没有遮罩", styles: [.arrowPosition(.center(offset: 0)), .dimFrame(.zero)])
        let roundStyleInfo = Marker.Info(marker: roundButton, intro: "第五个按钮, 圆角遮罩, 且高亮范围有 10px 的扩张", styles: [.cornerStyle(.round), .highlightRangeExpande(10)])
        let squareStyleInfo = Marker.Info(marker: squareButton, intro: "第六个按钮, 方形遮罩", styles: [.cornerStyle(.square)])
        let followStyleInfo = Marker.Info(marker: followStyleButton, intro: "第七个按钮, 跟随视图的风格, 视图是圆角就是圆角，方形就是方形, 高亮范围有 4px 的扩张", styles: [.cornerStyle(.marker), .highlightRangeExpande(4)])

        Marker(startInfo, identifier: "normal")
            .nexts([number2Info, actionInfo, noMaskInfo, roundStyleInfo, squareStyleInfo, followStyleInfo])
            .show(on: self.view, completion: nil)
    }
    
    @IBAction func outAction(_ sender: UIButton!) {
        print("被点击到了: \(sender.currentTitle ?? "NOT FOUND")")
    }
    
    @IBAction func inAction(_ sender: Any) {
        print("In action tapped.")
    }
}

