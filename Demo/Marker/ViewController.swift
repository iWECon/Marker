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
        
        topLeftButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
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
    
    @objc func tapAction(sender: UIButton) {
        Marker.default.timeoutAfterAnimateDidCompletion = true
        Marker.default.timeout = 0
        
        let marker = Marker(.init(marker: bottomLeftButton, intro: "你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的你的", prefixImage: .init(UIImage(named: "panci")), suffixImage: .init(UIImage(named: "panci")), maxWidth: 400))
            .next(.init(marker: topLeftButton, intro: "我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的", maxWidth: 320, style: .round))
            .next(.init(marker: topRightButton, intro: "她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的她的", maxWidth: 320, dimFrame: .zero))
            .next(.init(marker: buttons.first, intro: "第一个", highlightOnly: true, completion: { (_, isTriggerByUser) in
                print("is trigger by user: ", isTriggerByUser)
            }))
            .next(.init(marker: buttons[1], intro: "第二个", completion: { (_, isTriggerByUser) in
                print("is trigger by user: ", isTriggerByUser)
            }))
            .next(.init(marker: buttons[2], intro: "第三个"))
            .next(.init(marker: buttons[3], intro: "第四个"))
            .next(.init(marker: bottomRightButton, intro: "它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的它的", maxWidth: 320, enlarge: 20))
        
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

