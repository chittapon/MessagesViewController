//
//  MessagesAvatarImage.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 28/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit

class MessagesAvatarImage: MessageAvatarImageData {

    var avatarImage: UIImage?
    var avatarPlaceholderImage: UIImage?
    
    convenience init(image: UIImage?) {
        self.init(avatarImage: image, placeholderImage: nil)
    }
    
    class func avatarImage(withPlaceholder placeholderImage: UIImage) -> MessagesAvatarImage {
        return MessagesAvatarImage(avatarImage: nil, placeholderImage: placeholderImage)
    }
    
    init(avatarImage: UIImage?, placeholderImage: UIImage?) {
        self.avatarImage = avatarImage
        avatarPlaceholderImage = placeholderImage
    }
}
