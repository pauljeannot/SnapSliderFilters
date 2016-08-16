//
//  SNUtils.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

public class SNUtils {
    
    public static let screenSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    
    public static func screenShot(view: UIView?) -> UIImage? {
        guard let imageView = view else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, 0.0)
        imageView.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}