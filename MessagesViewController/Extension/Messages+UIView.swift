//
//  Messages+UIView.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 15/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pinAllEdgesOfSubview(_ subview: UIView) {
        pinSubview(subview, toEdge: .bottom)
        pinSubview(subview, toEdge: .top)
        pinSubview(subview, toEdge: .leading)
        pinSubview(subview, toEdge: .trailing)
    }
    
    func pinSubview(_ subview: UIView, toEdge attribute: NSLayoutAttribute) {
        NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0.0).isActive = true
    }
}
