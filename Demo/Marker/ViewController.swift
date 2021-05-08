//
//  ViewController.swift
//  Marker
//
//  Created by iWw on 2021/1/14.
//

import UIKit

class ViewController: UIViewController {
    
    let topLeftButton = UIButton(type: .custom)
    let topRightButton = UIButton(type: .custom)
    let bottomLeftButton = UIButton(type: .custom)
    let bottomRightButton = UIButton(type: .custom)
    
    var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        topLeftButton.setTitle("topLeft", for: .normal)
        topLeftButton.setTitleColor(.white, for: .normal)
        topLeftButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        topLeftButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(topLeftButton)
        
        topRightButton.setTitle("topRight", for: .normal)
        topRightButton.setTitleColor(.white, for: .normal)
        topRightButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        topRightButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(topRightButton)
        
        bottomLeftButton.setTitle("BottomLeft", for: .normal)
        bottomLeftButton.setTitleColor(.white, for: .normal)
        bottomLeftButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        bottomLeftButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(bottomLeftButton)
        
        bottomRightButton.setTitle("BottomRight", for: .normal)
        bottomRightButton.setTitleColor(.white, for: .normal)
        bottomRightButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        bottomRightButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(bottomRightButton)
        
        topLeftButton.addTarget(self, action: #selector(topLeftAlert(sender:)), for: .touchUpInside)
        topRightButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        bottomLeftButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        bottomRightButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        
        for index in 0 ..< 4 {
            let button = UIButton()
            button.setTitle("this is \(index)", for: .normal)
            button.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            button.sizeToFit()
            button.frame.origin = .init(x: (button.frame.width * CGFloat(index)) + 20 * CGFloat(index), y: 400)
            button.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
            view.addSubview(button)
            buttons.append(button)
        }
    }
    
    @objc func topLeftAlert(sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "透传事件", preferredStyle: .alert)
        alert.addAction(.init(title: "确认", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapAction(sender: UIButton) {
        Marker.default.timeoutAfterAnimateDidCompletion = true
        Marker.default.timeout = 0
        
        let marker = Marker(.init(marker: bottomLeftButton, intro: "这是左下角的按钮 BottomLeft", prefixImage: .init(UIImage(named: "panci")), suffixImage: .init(UIImage(named: "panci"))))
            .next(.init(marker: topLeftButton, intro: "右上角左边的按钮 TopLeft of Right, 该按钮仅点击高亮范围有效, 且点击事件会穿透下来. 该操作需要 highlightOnly 和 eventPenetration 同时为 true", maxWidth: 320, highlightOnly: true, eventPenetration: true))
            .next(.init(marker: topRightButton, intro: "这里的文本最大宽度可能超出320，但是设置了最大宽度为200，所以自动收缩了! \n这里的文本最大宽度可能超出200，但是设置了最大宽度为200，所以自动收缩了!\nTopRight of Right", maxWidth: 200))
            .next(.init(marker: buttons.first, intro: "遍历生成的第一个按钮，仅点击高亮范围才会触发下一步, 没有事件穿透.", highlightOnly: true, completion: { (_, isTriggerByUser) in
                print("is trigger by user: ", isTriggerByUser)
            }))
            .next(.init(marker: buttons[1], intro: "遍历生成的第二个按钮", completion: { (_, isTriggerByUser) in
                print("is trigger by user: ", isTriggerByUser)
            }))
            .next(.init(marker: buttons[2], intro: "遍历生成的第二个按钮"))
            .next(.init(marker: buttons[3], intro: "遍历生成的第二个按钮"))
            .next(.init(marker: bottomRightButton, intro: "右下角的按钮，使用 Enlarge 参数扩展了高亮范围.", maxWidth: 320, enlarge: 20))
        
        marker.show(on: view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topLeftButton.frame = .init(x: 150, y: 88, width: 64, height: 24)
        topRightButton.frame = .init(x: 200, y: 88, width: 120, height: 24)
        bottomLeftButton.frame = .init(x: 30, y: 488, width: 120, height: 24)
        bottomRightButton.frame = .init(x: 200, y: 488, width: 120, height: 120)
        
        bottomRightButton.layer.cornerRadius = 60
    }
}

