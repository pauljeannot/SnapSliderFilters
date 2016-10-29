//
//  SNFilter.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

open class SNFilter: UIImageView {
    
    // Full list of filters available here : https://developer.apple.com/library/tvos/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
    open static let filterNameList = ["No Filter" , "CIPhotoEffectFade", "CIPhotoEffectChrome", "CIPhotoEffectTransfer", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal"]
    open var name:String?
    var stickers = [SNSticker]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, withImage image:UIImage, withContentMode mode:UIViewContentMode = .scaleAspectFill) {
        super.init(frame: frame)
        self.contentMode = mode
        self.clipsToBounds = true
        self.image = image
        let maskLayer = CAShapeLayer()
        self.layer.mask = maskLayer
        maskLayer.frame = CGRect(origin: CGPoint.zero, size: self.image!.size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mask(_ maskRect: CGRect) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(maskRect)
        maskLayer.path = path
        self.layer.mask = maskLayer;
    }
    
    func updateMask(_ maskRect: CGRect, newXPosition: CGFloat) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        var rect = maskRect
        rect.origin.x = newXPosition
        path.addRect(rect)
        maskLayer.path = path
        self.layer.mask = maskLayer;
    }
    
    func applyFilter(filterNamed name:String) -> SNFilter {
        
        let filter:SNFilter = self.copy() as! SNFilter
        filter.name = name
        
        if (SNFilter.filterNameList.contains(name) == false) {
            print("Filter not existing")
            return filter
        }
        else if name == "No Filter" {
            return filter
        }
        else
        {
            // Create and apply filter
            // 1 - create source image
            let sourceImage = CIImage(image: filter.image!)
            
            // 2 - create filter using name
            let myFilter = CIFilter(name: name)
            myFilter?.setDefaults()
            
            // 3 - set source image
            myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
            
            // 4 - create core image context
            let context = CIContext(options: nil)
            
            // 5 - output filtered image as cgImage with dimension.
            let outputCGImage = context.createCGImage(myFilter!.outputImage!, from: myFilter!.outputImage!.extent)
            
            // 6 - convert filtered CGImage to UIImage
            let filteredImage = UIImage(cgImage: outputCGImage!)
            
            // 7 - set filtered image to array
            filter.image = filteredImage
            return filter
        }
    }
    
    open func addSticker(_ sticker: SNSticker) {
        self.stickers.append(sticker)
    }
    
    open static func generateFilters(_ originalImage: SNFilter, filters:[String]) -> [SNFilter] {
        
        var finalFilters = [SNFilter]()
        
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        let syncQueue = DispatchQueue(label: "com.snapsliderfilters.app", attributes: .concurrent)
        
        // Each filter can be generated on a different thread
        DispatchQueue.concurrentPerform(iterations: filters.count) { iteration in
            let filterComputed = originalImage.applyFilter(filterNamed: filters[iteration])
            syncQueue.sync {
                finalFilters.append(filterComputed)
                return
            }
        }
        
        return finalFilters
    }
}

// MARK: - NSCopying protocol

extension SNFilter: NSCopying {
    
    public func copy(with zone: NSZone?) -> Any {
        let copy = SNFilter(frame: self.frame)
        copy.backgroundColor = self.backgroundColor
        copy.image = self.image
        copy.name = name
        copy.contentMode = self.contentMode
        
        for s in stickers {
            copy.stickers.append(s.copy() as! SNSticker)
        }
        return copy
    }
}
