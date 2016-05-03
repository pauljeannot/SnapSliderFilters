//
//  SNSliderDataSource.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

public protocol SNSliderDataSource : class {
    
    func numberOfSlides(slider: SNSlider) -> Int
    
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter
    
    func startAtIndex(slider: SNSlider) -> Int
}

extension SNSliderDataSource {
    
    func numberOfSlides(slider: SNSlider) -> Int {
        
        return 3
    }
    
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        let filter = SNFilter(frame: slider.frame)
        switch index {
        case 0:
            filter.backgroundColor = UIColor.blackColor()
            return filter
        case 1:
            filter.backgroundColor = UIColor.greenColor()
            return filter
        case 2:
            filter.backgroundColor = UIColor.yellowColor()
            return filter
        default:
            filter.backgroundColor = UIColor.yellowColor()
            return filter
        }
    }
    
    func startAtIndex(slider: SNSlider) -> Int {
        return 0
    }
}
