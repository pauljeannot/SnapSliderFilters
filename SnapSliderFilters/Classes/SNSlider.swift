//
//  SNSlider.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

public class SNSlider: UIView {
    
    private var slider:UIScrollView
    private var numberOfPages:Int
    private var startingIndex:Int
    private var data = [SNFilter]()
    
    public weak var dataSource:SNSliderDataSource?
    
    public override init(frame: CGRect) {
        
        numberOfPages = 3
        startingIndex = 0
        slider = UIScrollView(frame: frame)
        
        super.init(frame: frame)
        
        self.slider.delegate = self
        self.slider.pagingEnabled = true
        self.slider.bounces = false
        self.slider.showsHorizontalScrollIndicator = false
        self.slider.showsVerticalScrollIndicator = false
        self.slider.layer.zPosition = 1
        self.addSubview(self.slider)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        self.loadData()
        self.presentData()
    }
    
    public func slideShown() -> SNFilter {
        let index = self.slider.contentOffset.x / slider.frame.size.width
        return data[Int(index)]
    }
    
    private func loadData() {
        self.numberOfPages = dataSource!.numberOfSlides(self)
        self.startingIndex = dataSource!.startAtIndex(self)
        self.slider.contentSize = CGSize(width: self.frame.width*(CGFloat(numberOfPages+2)), height: self.frame.height)
        
        var filter = dataSource!.slider(self, slideAtIndex:self.numberOfPages-1).copy() as! SNFilter
        data.append(filter)
        
        for i in 0..<self.numberOfPages {
            let filter = dataSource!.slider(self, slideAtIndex:i)
            data.append(filter)
        }
        
        filter = dataSource!.slider(self, slideAtIndex:0).copy() as! SNFilter
        data.append(filter)
        
        self.slider.scrollRectToVisible(CGRect(x: positionOfPageAtIndex(startingIndex),y: 0,width: self.frame.width,height: self.frame.height), animated:false);
    }
    
    private func presentData() {
        
        for i in 0..<data.count {
            weak var filter:SNFilter! = data[i]
            filter.layer.zPosition = 0
            filter.mask(filter.frame)
            filter.updateMask(filter.frame, newXPosition: positionOfPageAtIndex(i-startingIndex-2))
            self.addSubview(filter)
            
            for s in data[i].stickers {
                s.frame.origin.x = s.frame.origin.x + positionOfPageAtIndex(i-1)
                self.slider.addSubview(s)
            }
        }
    }
    
    private func positionOfPageAtIndex(index: Int) -> CGFloat {
        return self.frame.size.width*CGFloat(index) + self.frame.size.width
    }
}

extension SNSlider: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        for i in 0..<data.count {
            data[i].updateMask(data[i].frame, newXPosition: positionOfPageAtIndex(i-1)-scrollView.contentOffset.x)
        }
        
        
    } // Well synchronized with the scrolling position : scrollView.contentOffset.x
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x == positionOfPageAtIndex(-1)) {
            self.slider.scrollRectToVisible(CGRect(x: positionOfPageAtIndex(numberOfPages-1),y: 0,width: self.frame.width,height: self.frame.height), animated:false);
        }
        else if (scrollView.contentOffset.x == positionOfPageAtIndex(numberOfPages)) {
            self.slider.scrollRectToVisible(CGRect(x: positionOfPageAtIndex(0),y: 0,width: self.frame.width,height: self.frame.height), animated:false);
        }
    } // Works great
    
}