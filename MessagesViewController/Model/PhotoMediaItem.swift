//
//  PhotoMediaItem.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 19/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import IGListKit

class PhotoMediaItem: MediaItem {
    
    var image: UIImage?
    var cachedImageView: UIImageView!
    
    init(image: UIImage?) {
        self.image = image
        super.init(isOutgoing: true)
    }
    
    override init(isOutgoing: Bool) {
        super.init(isOutgoing: isOutgoing)
    }

    override var mediaView: UIView? {
        if self.image == nil {
            return nil
        }
        if cachedImageView == nil {

            let size = self.mediaViewDisplaySize // 60% of full width
            let point = CGPoint.zero
            let frame = CGRect(origin: point, size: size)
            let imageView = UIImageView(image: image)
            imageView.frame = frame
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
            self.cachedImageView = imageView
        }
        return cachedImageView
    }
    
    override func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        super.setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing)
        cachedImageView = nil
    }
}
