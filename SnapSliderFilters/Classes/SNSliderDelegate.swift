//
//  SNSliderDelegate.swift
//  Pods
//
//  Created by Quentin Arnault on 18/11/2018.
//

import Foundation

public protocol SNSliderDelegate : class {
    func slider(_ slider: SNSlider, didSlideAtIndex index: Int)
}
