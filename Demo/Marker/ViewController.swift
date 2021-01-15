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
    }
    
    @objc func tapAction(sender: UIButton) {
//        let marker = Marker(tips: "你妹的你妹的你妹的你妹的你妹的你妹的你妹的你妹的", mark: sender, frame: view.bounds)
//        marker.show(on: view)
        
        Marker(mark: topLeftButton, tips: "你妹的你妹的你妹的你妹的你妹的你妹的", on: view)
            .next(mark: topRightButton, tips: "你爹的你爹的你爹的你爹的你爹的你爹的你爹的你爹", dimmingFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
            .next(mark: bottomLeftButton, tips: "niniangdeniniangdeniniangdeniniangdeniniangdeniniangdeniniangdeniniangde")
            .next(mark: bottomRightButton, tips: "奥isjdfoijasodijfoqiogioasvoijoijqwoetemo😈")
            .show()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topLeftButton.frame = .init(x: 0, y: 88, width: 64, height: 24)
        topRightButton.frame = .init(x: 300, y: 88, width: 64, height: 24)
        bottomLeftButton.frame = .init(x: 30, y: 488, width: 64, height: 24)
        bottomRightButton.frame = .init(x: 300, y: 488, width: 64, height: 24)
    }
}

