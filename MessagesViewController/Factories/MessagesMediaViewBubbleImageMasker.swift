//
//  MessagesMediaViewBubbleImageMasker.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 24/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit

class MessagesMediaViewBubbleImageMasker {

    lazy var imageCapInsets = UIEdgeInsetsMake(17, 21, 17, 21)
    
    func applyOutgoingBubbleImageMask(toMediaView mediaView: UIView) {
        let bubbleImage = #imageLiteral(resourceName: "chat_bubble_sent").resizableImage(withCapInsets: imageCapInsets)
        maskView(mediaView, withImage: bubbleImage)
    }
    
    func applyIncomingBubbleImageMask(toMediaView mediaView: UIView) {
        let bubbleImage = #imageLiteral(resourceName: "chat_bubble_received").resizableImage(withCapInsets: imageCapInsets)
        maskView(mediaView, withImage: bubbleImage)
    }
    
    class func applyBubbleImageMask(toMediaView mediaView: UIView, isOutgoing: Bool) {
        let masker = MessagesMediaViewBubbleImageMasker()
        if isOutgoing {
            masker.applyOutgoingBubbleImageMask(toMediaView: mediaView)
        }
        else {
            masker.applyIncomingBubbleImageMask(toMediaView: mediaView)
        }
    }
    
    func maskView(_ view: UIView, withImage image: UIImage) {
        let imageViewMask = UIImageView(image: image)
        imageViewMask.frame = view.frame
        view.layer.mask = imageViewMask.layer
    }
}
