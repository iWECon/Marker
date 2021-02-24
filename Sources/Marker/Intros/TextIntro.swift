//
//  TextIntro.swift
//  Marker
//
//  Created by iWw on 2021/2/24.
//

import UIKit


public extension Marker.Info {
    
    struct Text: IntroValidation {
        var intro: String?
        var attributedIntro: NSAttributedString?
        
        public init(_ intro: String?) {
            self.intro = intro
        }
        
        public init(_ intro: NSAttributedString?) {
            self.attributedIntro = intro
        }
        
        public var isValidate: Bool {
            intro != nil || attributedIntro != nil
        }
    }
}

public extension Marker.Info {
    
    convenience init(_ marker: UIView?, intro: Text) {
        self.init()
        self.marker = marker
        self.intro = intro
    }
    
    convenience init(_ marker: UIView?, intro: String?) {
        self.init()
        self.marker = marker
        self.intro = Text(intro)
    }
    
    convenience init(_ marker: UIView?, intro: NSAttributedString?) {
        self.init()
        self.marker = marker
        self.intro = Text(intro)
    }
}
