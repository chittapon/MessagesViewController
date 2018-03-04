//
//  Messages+UIImage.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 27/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func imageMasked(with maskColor: UIColor) -> UIImage {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: self.size)
        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
//        context?.scaleBy(x: 1.0, y: -1.0)
//        context?.translateBy(x: 0.0, y: -imageRect.size.height)
        context?.clip(to: imageRect, mask: self.cgImage!)
        context?.setFillColor(maskColor.cgColor)
        context?.fill(imageRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return newImage
    }
}
