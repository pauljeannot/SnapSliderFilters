//
//  SNSticker.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

open class SNSticker: UIImageView {
    
    public init(frame: CGRect, image:UIImage, withContentMode mode: UIViewContentMode = .scaleAspectFit, atZPosition zIndex:CGFloat? = nil) {
        super.init(frame: frame)
        
        self.contentMode = mode
        self.clipsToBounds = true
        self.image = image
        if let index = zIndex {
            self.layer.zPosition = index
        }
        else {
            self.layer.zPosition = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK : - NSCopying protocol 

extension SNSticker: NSCopying {
    
    public func copy(with zone: NSZone?) -> Any {
        let copy = SNSticker(frame: self.frame, image: (self.image)!, withContentMode: self.contentMode)
        return copy
    }
}
