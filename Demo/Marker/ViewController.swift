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
        
        let attributedString = NSMutableAttributedString(string: "2⃣️ 生成的第二个按钮")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 18, weight: .heavy)], range: NSMakeRange(0, attributedString.string.utf16.count))
        
        let marker = Marker(.init(bottomLeftButton, intro: "左下角的按钮, 只能点击高亮范围才能触发下一个").highlightOnly())
            .next(.init(nil, intro: UIImage(named: "panci"), size: .init(width: 100, height: 100)))
            .next(.init(topRightButton, intro: "右上角右边的按钮"))
            .next(.init(buttons.first, intro: "生成的第一个按钮"))
            .next(.init(buttons[1], intro: attributedString))
            .next(.init(buttons[2], intro: "生成的第三个按钮").backgroundHidden())
            .next(.init(buttons[3], intro: "生成的第四个按钮"))
            .next(.init(bottomRightButton, intro: "右下角一个非常大的按钮"))
        
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

