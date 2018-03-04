//
//  MediaItem.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 19/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//
import UIKit

class MediaItem: NSObject, MessageMediaData {
    
    var appliesMediaViewMaskAsOutgoing: Bool
    
    var mediaView: UIView? { return nil }
    
    var mediaViewDisplaySize: CGSize {
        let percent: CGFloat = 0.6
        let width: CGFloat = UIScreen.main.bounds.width * percent
        return CGSize(width: width, height: 150.0)
    }
    
    var cachedPlaceholderView: UIView!
    
    var mediaPlaceholderView: UIView {
        if cachedPlaceholderView == nil {
            let size = self.mediaViewDisplaySize
            let view = UIView()
            view.backgroundColor = .lightGray
            view.frame.size = size
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator)
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            activityIndicator.startAnimating()
            MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: view, isOutgoing: appliesMediaViewMaskAsOutgoing)
            self.cachedPlaceholderView = view
        }
        return cachedPlaceholderView
    }

    init(isOutgoing: Bool) {
        self.appliesMediaViewMaskAsOutgoing = isOutgoing
    }
    
    func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        self.appliesMediaViewMaskAsOutgoing = appliesMediaViewMaskAsOutgoing
        cachedPlaceholderView = nil
    }
    
    func clearCachedMediaViews() {
        cachedPlaceholderView = nil
    }
}
