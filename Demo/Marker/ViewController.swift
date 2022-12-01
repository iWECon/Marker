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
        let marker = Marker(.init(marker: bottomButton, intro: "Marker guide, all configurate is default. auto handle and display.\n所有配置都是默认的。"), identifier: "bottom")
        marker.next(.init(marker: bottomButtons[0], intro: "Support control triangle arrow position (left, center, right) and offset.\n支持三角箭头位置调整(左/中/右), 且可调整偏移量, 本次显示为自动处理三角箭头位置."))
        marker.next(.init(marker: bottomButtons[1], intro: "Triangle arrow on left, and offset set 10.\n本次三角箭头在左侧，且向右偏移 10px.", styles: [.arrowPosition(.left(offset: 10))]))
        marker.next(.init(marker: bottomButtons[2], intro: "Triangle arrow on right, and offset set -10.\n本次三角箭头在右侧，且向左偏移 10px.", styles: [.arrowPosition(.right(offset: -10))]))
        marker.next(.init(marker: bottomButtons[3], intro: "Triangle arrow on center (default value).\n居中，默认处理方式。", styles: [.arrowPosition(.center(offset: 0))]))
        marker.next(.init(marker: bottomButtons[4], intro: "Align left. triangle position auto handle.\n左对齐，三角箭头自动处理。", styles: [.hAlignment(.left)]))
        marker.next(.init(marker: bottomButtons[5], intro: "Align right. triangle position auto handle.\n右对齐，三角箭头自动处理。", styles: [.hAlignment(.right)]))
        marker.show(on: self.view, completion: nil)
    }
    
    @objc func respondAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pass event 事件穿透", message: "You click on the highlighted range and the click event is passed to the button.\n你点击了高亮范围，并且事件被传递到了按钮上.", preferredStyle: .alert)
        alert.addAction(.init(title: "I know 我晓得了", style: .cancel, handler: { _ in
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
        
        let startInfo = Marker.Info(marker: startButton, intro: "Description.\n样式描述。")
        let number2Info = Marker.Info(marker: number2Button, intro: "styles: [.hideArrow], no triangle arrow.\n没有三角指示箭头。", styles: [.hideArrow])
        let actionInfo = Marker.Info(marker: respondActionButton, intro: "options: [.strongGuidance, .eventPenetration], now you can tap the button.\n强引导和事件穿透，你可以点击触发按钮的响应事件了。", options: [.strongGuidance, .eventPenetration])
        let noMaskInfo = Marker.Info(marker: noMaskButton, intro: "styles: [.dimFrame(.zero)], no gray mask.\n没有遮罩。", styles: [.dimFrame(.zero)])
        let roundStyleInfo = Marker.Info(marker: roundButton, intro: "styles: [.cornerStyle(.round), .highlightRangeExpande(10)], highlight range is round and it has a 10px expande.\n圆角遮罩, 且高亮范围有 10px 的扩张。", styles: [.cornerStyle(.round), .highlightRangeExpande(10)])
        let squareStyleInfo = Marker.Info(marker: squareButton, intro: "styles: [.timeout(2)], timeout 2 seconds.\n两秒后自动消失。", styles: [.timeout(2)])
        let followStyleInfo = Marker.Info(marker: followStyleButton, intro: "More details see: `Marker+Info+Style` and `Marker+Info+Option`.\n更多信息请参考`Marker+Info+Style` 和 `Marker+Info+Option`。", styles: [.cornerStyle(.marker), .highlightRangeExpande(4)])

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

