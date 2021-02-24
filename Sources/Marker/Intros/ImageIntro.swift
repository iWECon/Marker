//
//  ImageIntro.swift
//  Marker
//
//  Created by iWw on 2021/2/24.
//

import UIKit

public extension Marker.Info {
    
    struct Image: IntroValidation {
        var image: UIImage?
        var size: CGSize?
        
        var isValidate: Bool {
            image != nil
        }
        
        public init(_ intro: UIImage?, size: CGSize? = nil) {
            self.image = intro
            self.size = size
        }
    }
}

public extension Marker.Info {
    
    convenience init(_ marker: UIView?, intro: Image) {
        self.init()
        self.marker = marker
        self.intro = intro
    }
    
    convenience init(_ marker: UIView?, intro: UIImage?, size: CGSize? = nil) {
        self.init()
        self.marker = marker
        self.intro = Image(intro, size: size)
    }
}
