//
//  MessagesSectionController.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 13/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit
import IGListKit

protocol MessageAvatarImageDataSource: class {
    func messagesSectionController(avatarImageWith object: Message) -> MessageAvatarImageData?
}

class MessagesSectionController: ListSectionController {

    weak var avatarImageDataSource: MessageAvatarImageDataSource?
    var object: Message!
    var cacheTextSize = [Int: CGSize]()
    
    override init() {
        super.init()

        inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell: MessagesCollectionViewCell
        
        if object.isOutgoing {
            
            cell = collectionContext?.dequeueReusableCell(withNibName: "MessagesOutgoingCollectionViewCell", bundle: nil, for: self, at: index) as! MessagesCollectionViewCell
        }else {
            
            cell = collectionContext?.dequeueReusableCell(withNibName: "MessagesIncomingCollectionViewCell", bundle: nil, for: self, at: index) as! MessagesCollectionViewCell
        }
        
        let textSize = cacheTextSize[index] ?? collectionContext!.containerSize
        let avatarImageData = self.avatarImageDataSource?.messagesSectionController(avatarImageWith: object)
        cell.configCell(message: object, textViewSize: textSize, avatarImageData: avatarImageData)
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        let size: CGSize
        if object.isMediaMessage {
            size = object.media?.mediaViewDisplaySize ?? CGSize.zero
        }else {
            size = MessagesCollectionViewCell.textSize(object, width: width)
        }
        self.cacheTextSize[index] = size
        return CGSize(width: width, height: size.height)
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as! Message
    }
    
    override func didSelectItem(at index: Int) {
        
        if let media = object.media {
            switch media{
                
            case _ where media is LocationMediaItem:
                print("Location")
                break
                
            case _ where media is PhotoMediaItem:
                print("Photo")
                break
                
            case _ where media is VideoMediaItem:
                print("Video")
                break
                
            case _ where media is AudioMediaItem:
                print("Audio")
                break
                
            default:
                break
            }
        }
    }
}
