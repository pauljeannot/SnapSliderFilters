//
//  SNSlider.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

open class SNSlider: UIView {
    
    fileprivate var slider:UIScrollView
    fileprivate var numberOfPages:Int
    fileprivate var startingIndex:Int
    fileprivate var data = [SNFilter]()
    fileprivate let slideAxis: SlideAxis
    
    open weak var dataSource:SNSliderDataSource?
    
    public init(frame: CGRect, slideAxis: SlideAxis = .horizontal) {
        
        self.slideAxis = slideAxis
        numberOfPages = 3
        startingIndex = 0
        slider = UIScrollView(frame: CGRect(origin: CGPoint.zero,
                                            size: frame.size))
        
        super.init(frame: frame)
        
        self.slider.delegate = self
        self.slider.isPagingEnabled = true
        self.slider.bounces = false
        self.slider.showsHorizontalScrollIndicator = false
        self.slider.showsVerticalScrollIndicator = false
        self.slider.layer.zPosition = 1
        self.addSubview(self.slider)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func reloadData() {
        self.cleanData()
        self.loadData()
        self.presentData()
    }
    
    open func slideShown() -> SNFilter {
        let index = slideAxis.index(with: slider)
        return data[Int(index)]
    }
    
    fileprivate func cleanData() {
        for v in subviews {
            let filter = v as? SNFilter
            if filter != nil {
                v.removeFromSuperview()
            }
        }
        
        for s in slider.subviews {
            let sticker = s as? SNSticker
            if  sticker != nil {
                s.removeFromSuperview()
            }
        }
        
        data.removeAll()
    }
    
    fileprivate func loadData() {
        
        self.numberOfPages = dataSource!.numberOfSlides(self)
        self.startingIndex = dataSource!.startAtIndex(self)
        self.slider.contentSize = slideAxis.contentSize(with: self)
        
        var filter = dataSource!.slider(self, slideAtIndex:self.numberOfPages-1).copy() as! SNFilter
        data.append(filter)
        
        for i in 0..<self.numberOfPages {
            let filter = dataSource!.slider(self, slideAtIndex:i)
            data.append(filter)
        }
        
        filter = dataSource!.slider(self, slideAtIndex:0).copy() as! SNFilter
        data.append(filter)
        
        self.slider.scrollRectToVisible(slideAxis.rect(at: startingIndex, in: self),
                                        animated:false);
    }
    
    fileprivate func presentData() {
        
        for i in 0..<data.count {
            weak var filter:SNFilter! = data[i]
            filter.layer.zPosition = 0
            filter.mask(filter.frame)
            switch slideAxis {
            case .horizontal:
                filter.updateMask(filter.frame, newXPosition: slideAxis.positionOfPage(at: (i-startingIndex-2), in: self))
            case .vertical:
                filter.updateMask(filter.frame, newYPosition: slideAxis.positionOfPage(at: (i-startingIndex-2), in: self))
            }
            self.addSubview(filter)
            
            for s in data[i].stickers {
                switch slideAxis {
                case .horizontal:
                    s.frame.origin.x = s.frame.origin.x + slideAxis.positionOfPage(at: i - 1, in: self)
                case .vertical:
                    s.frame.origin.y = s.frame.origin.y + slideAxis.positionOfPage(at: i - 1, in: self)
                }
                
                self.slider.addSubview(s)
            }
        }
    }
}

// MARK: - Scroll View Delegate

extension SNSlider: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for i in 0..<data.count {
            switch slideAxis {
            case .horizontal:
                data[i].updateMask(data[i].frame, newXPosition: slideAxis.positionOfPage(at: i - 1, in: self) - scrollView.contentOffset.x)
            case .vertical:
                data[i].updateMask(data[i].frame, newYPosition: slideAxis.positionOfPage(at: i - 1, in: self) - scrollView.contentOffset.y)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch slideAxis {
        case .horizontal:
            if (scrollView.contentOffset.x == slideAxis.positionOfPage(at: -1, in: self)) {
                self.slider.scrollRectToVisible(slideAxis.rect(at: numberOfPages - 1, in: self),
                                                animated:false);
        }
            else if (scrollView.contentOffset.x == slideAxis.positionOfPage(at: numberOfPages, in: self)) {
            self.slider.scrollRectToVisible(slideAxis.rect(at: 0, in: self),
                                            animated:false);
        }
        case .vertical:
            if (scrollView.contentOffset.y == slideAxis.positionOfPage(at: -1, in: self)) {
                self.slider.scrollRectToVisible(slideAxis.rect(at: numberOfPages - 1, in: self),
                                                animated:false);
            }
            else if (scrollView.contentOffset.y == slideAxis.positionOfPage(at: numberOfPages, in: self)) {
                self.slider.scrollRectToVisible(slideAxis.rect(at: 0, in: self),
                                                animated:false);
            }
        }
    }
}

extension SNSlider {
    public enum SlideAxis {
        case horizontal
        case vertical

        func contentSize(with slider: SNSlider) -> CGSize {
            switch self {
            case .horizontal:
                return CGSize(width: slider.frame.width*(CGFloat(slider.numberOfPages + 2)),
                              height: slider.frame.height)
            case .vertical:
                return CGSize(width: slider.frame.width,
                              height: slider.frame.height * (CGFloat(slider.numberOfPages + 2)))
            }
        }
        
        func index(with slider: UIScrollView) -> Int {
            switch self {
            case .horizontal: return Int(slider.contentOffset.x / slider.frame.size.width)
            case .vertical: return Int(slider.contentOffset.y / slider.frame.size.height)
            }
        }
        
        func rect(at index: Int, in slider: SNSlider) -> CGRect {
            switch self {
            case .horizontal: return CGRect(x: positionOfPage(at: index, in: slider),
                                            y: 0.0,
                                            width: slider.frame.width,
                                            height: slider.frame.height)
            case .vertical: return CGRect(x: 0.0,
                                          y: positionOfPage(at: index, in: slider),
                                          width: slider.frame.width,
                                          height: slider.frame.height)
            }
        }
        
        func positionOfPage(at index: Int, in slider: SNSlider) -> CGFloat {
            switch self {
            case .horizontal: return slider.frame.size.width * CGFloat(index) + slider.frame.size.width
            case .vertical: return slider.frame.size.height + slider.frame.size.height  * CGFloat(index)
            }
        }
    }
}
