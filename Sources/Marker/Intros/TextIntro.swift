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
        
        var prefixImage: Image?
        var suffixImage: Image?
        
        var finallyIntro: Any {
            if let intro = intro {
                if prefixImage != nil || suffixImage != nil {
                    return makeString(intro, prefixImageInfo: prefixImage, suffixImageInfo: suffixImage)
                }
                return intro
            }
            // attributed intro
            if prefixImage != nil || suffixImage != nil {
                return makeString(attributedIntro!, prefixImageInfo: prefixImage, suffixImageInfo: suffixImage)
            }
            return attributedIntro!
        }
        
        func makeString(_ string: Any, prefixImageInfo: Image?, suffixImageInfo: Image?) -> NSAttributedString {
            
            // make attachment view
            func makeAttachString(_ image: Image?) -> NSAttributedString? {
                guard let image = image else { return nil }
                
                let offsetY = image.offsetY
                let imageSize = image.size ?? .zero
                
                let attach = NSTextAttachment()
                attach.image = image.image
                attach.bounds = .init(x: 0, y: -offsetY,
                                      width: imageSize.width, height: imageSize.height)
                return NSAttributedString(attachment: attach)
            }
            
            let mutableAttr: NSMutableAttributedString
            if string is String {
                mutableAttr = NSMutableAttributedString(string: string as! String)
            } else if string is NSAttributedString {
                mutableAttr = NSMutableAttributedString(attributedString: string as! NSAttributedString)
            } else {
                fatalError("...")
            }
            
            let prefixString: NSAttributedString? = makeAttachString(prefixImageInfo)
            if let ps = prefixString {
                mutableAttr.insert(ps, at: 0)
            }
            let suffixString: NSAttributedString? = makeAttachString(suffixImageInfo)
            if let ss = suffixString {
                mutableAttr.append(ss)
            }
            return mutableAttr
        }
        
        public struct Image {
            var image: UIImage?
            var offsetY: CGFloat = 0
            var size: CGSize?
            
            public init(_ image: UIImage?, offsetY: CGFloat, size: CGSize? = nil) {
                self.image = image
                self.size = size ?? image?.size
                self.offsetY = offsetY
            }
        }
        
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
    
    convenience init(_ marker: UIView?, intro: String?, prefixImage: Text.Image? = nil, suffixImage: Text.Image? = nil) {
        self.init()
        self.marker = marker
        
        var intro = Text(intro)
        intro.prefixImage = prefixImage
        intro.suffixImage = suffixImage
        self.intro = intro
    }
    
    convenience init(_ marker: UIView?, intro: NSAttributedString?, prefixImage: Text.Image? = nil, suffixImage: Text.Image? = nil) {
        self.init()
        self.marker = marker
        
        var intro = Text(intro)
        intro.prefixImage = prefixImage
        intro.suffixImage = suffixImage
        self.intro = intro
    }
}
