//
//  Message.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 12/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import IGListKit

@objc protocol MessageData {
    
    var isOutgoing: Bool { get }
    var senderId: String { get }
    var senderDisplayName: String { get }
    var date: Date { get }
    var isMediaMessage: Bool { get }
    
    @objc optional var text: String? { get }
    @objc optional var media: MessageMediaData? { get }
    
}

@objc protocol MessageMediaData {
    
    var appliesMediaViewMaskAsOutgoing: Bool { get }
    var mediaView: UIView? { get }
    var mediaViewDisplaySize: CGSize { get }
    var mediaPlaceholderView: UIView { get }

    @objc optional var mediaDataType: String { get }
    @objc optional var mediaData: Any { get }
    
}

protocol MessageAvatarImageData {
    var avatarImage: UIImage? { get }
    var avatarPlaceholderImage: UIImage? { get }
}

class Message: MessageData, ListDiffable {
    
    var isOutgoing: Bool
    var senderId: String
    var senderDisplayName: String
    var date: Date
    var isMediaMessage: Bool
    var media: MessageMediaData?
    var text: String?
    
    convenience init(isOutgoing: Bool, senderId: String, displayName: String, text: String) {
        self.init(isOutgoing: isOutgoing, senderId: senderId, senderDisplayName: displayName, date: Date(), text: text)
    }
    
    convenience init(isOutgoing: Bool, senderId: String, displayName: String, media: MessageMediaData) {
        self.init(isOutgoing: isOutgoing, senderId: senderId,senderDisplayName: displayName, date: Date(), media: media)
    }
    
    init(isOutgoing: Bool, senderId: String, senderDisplayName: String, date: Date, text: String) {
        self.senderId = senderId
        self.isOutgoing = isOutgoing
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.text = text
        self.isMediaMessage = false
    }
    
    init(isOutgoing: Bool, senderId: String, senderDisplayName: String, date: Date, media: MessageMediaData) {
        self.senderId = senderId
        self.isOutgoing = isOutgoing
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.media = media
        self.isMediaMessage = true
    }
    
    // MARK: - ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as! NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return object === self
    }
}
