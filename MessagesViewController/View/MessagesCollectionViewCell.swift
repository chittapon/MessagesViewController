//
//  MessagesCollectionViewCell.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 14/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit

class MessagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bubbleContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var cellBesideLabel: UILabel!
    @IBOutlet weak var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerViewHeightConstraint: NSLayoutConstraint!
    
    private let messageBubbleFont = UIFont.systemFont(ofSize: 14)
    private let textViewTextContainerInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
    private let textViewFrameInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //private let additionalInset: CGFloat = 2
    private let minimumBubbleWidth: CGFloat = 43
    
    weak var mediaView: UIView! {
        didSet {
            setMediaView()
        }
    }

    lazy var messagesCellTextView: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = textViewTextContainerInsets
        textView.font = messageBubbleFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.textColor = .white
        textView.isEditable = false
        return textView
    }()
    
    private let bubleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let outgoingBubleImage: UIImage = {
        let image = #imageLiteral(resourceName: "chat_bubble_sent")
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch)
        return image
    }()
    
    private let incomingBubleImage: UIImage = {
        let image = #imageLiteral(resourceName: "chat_bubble_received")
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch)
        return image
    }()
    
    static func textSize(_ message: Message, width: CGFloat) -> CGSize {
        let cell = self.init()
        
        let maximumTextwidth: CGFloat
//        if message.isOutgoing {
//            maximumTextwidth = width - sectionInset - 57 - 6 - cell.textViewTextContainerInsets.left - cell.textViewTextContainerInsets.right - 8
//        }else {
//            maximumTextwidth = width - sectionInset - 8 - 34 - 6 - cell.textViewTextContainerInsets.left - cell.textViewTextContainerInsets.right - 57
//        }
//

        let horizontalContainerInsets = cell.textViewTextContainerInsets.left + cell.textViewTextContainerInsets.right
        let horizontalFrameInsets = cell.textViewFrameInsets.left + cell.textViewFrameInsets.right
        let horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets
        
        let sectionInset: CGFloat = 8
        let avatarWidth: CGFloat = 34
        let dateWidth: CGFloat = 57
        if message.isOutgoing {
            let spacingBetweenDateAndBubble: CGFloat = 6
            let spacingBetweenBubbleAndContentView: CGFloat = 8
            maximumTextwidth = width - horizontalInsetsTotal - sectionInset - dateWidth - spacingBetweenDateAndBubble - spacingBetweenBubbleAndContentView
        }else {
            let spacingBetweenContentViewAndAvatar: CGFloat = 8
            let spacingBetweenAvatarAndBuble: CGFloat = 6
            let spacingBetweenDateAndBubble: CGFloat = 6
            maximumTextwidth = width - horizontalInsetsTotal - sectionInset - spacingBetweenContentViewAndAvatar - avatarWidth - spacingBetweenAvatarAndBuble - spacingBetweenDateAndBubble - dateWidth
        }
        
        let constrainedSize = CGSize(width: maximumTextwidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedStringKey.font: cell.messageBubbleFont]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let stringRect = (message.text! as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        let stringSize = stringRect.integral.size
        let verticalContainerInsets = cell.textViewTextContainerInsets.top + cell.textViewTextContainerInsets.bottom
        let verticalFrameInsets = cell.textViewFrameInsets.top + cell.textViewFrameInsets.bottom
        let verticalInsets = verticalContainerInsets + verticalFrameInsets //+ cell.additionalInset
        
        let finalWidth = max(stringSize.width + horizontalInsetsTotal, cell.minimumBubbleWidth) //+ cell.additionalInset
        return CGSize(width: finalWidth, height: stringSize.height + verticalInsets)
    }
    
    private func setMediaView() {
        
        _ = bubbleContainerView.subviews.map({ $0.removeFromSuperview() })
        self.mediaView.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleContainerView.addSubview(mediaView)
        messageBubbleContainerWidthConstraint.constant = self.mediaView.bounds.width
        self.bubbleContainerView.pinAllEdgesOfSubview(mediaView)
        self.needsUpdateConstraints()

    }
    
    func configCell(message: Message?, textViewSize size: CGSize, avatarImageData: MessageAvatarImageData?){
        
        guard let message = message else { return }
        if message.isMediaMessage {
            
            let messageMedia = message.media
            mediaView = messageMedia?.mediaView ?? messageMedia?.mediaPlaceholderView
            
        }else{
            
            _ = bubbleContainerView.subviews.map({ $0.removeFromSuperview() })
            bubbleContainerView.addSubview(bubleImageView)
            bubbleContainerView.pinAllEdgesOfSubview(bubleImageView)
            bubbleContainerView.addSubview(messagesCellTextView)
            pinTextView()
            messageBubbleContainerWidthConstraint.constant = size.width + textViewTextContainerInsets.left - textViewTextContainerInsets.right
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "ddMMMyy"
            let dateString = dateFormatter.string(from: message.date)
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: message.date)
            cellBesideLabel.text = "\(dateString)\n\(timeString)"
            messagesCellTextView.text = message.text
            bubleImageView.image = message.isOutgoing ? outgoingBubleImage : incomingBubleImage
            if message.isOutgoing {
                bubleImageView.tintColor = UIColor.bubble_color_sent_default
            }
            else {
                bubleImageView.tintColor = UIColor.messageBubbleGreenColor
            }
            
        }
        
        avatarImageView?.layer.cornerRadius = avatarImageView.bounds.width/2
        if let avatarImageData = avatarImageData {
            avatarImageView?.image = avatarImageData.avatarImage
        }
    }
    
    private func pinTextView() {
        
        NSLayoutConstraint(item: messagesCellTextView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: bubbleContainerView,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: textViewFrameInsets.left).isActive = true
        
        NSLayoutConstraint(item: messagesCellTextView,
                           attribute: .top,
                           relatedBy: .greaterThanOrEqual,
                           toItem: bubbleContainerView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: textViewFrameInsets.top).isActive = true
        
        NSLayoutConstraint(item: bubbleContainerView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: messagesCellTextView,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: textViewFrameInsets.right).isActive = true
        
        NSLayoutConstraint(item: bubbleContainerView,
                           attribute: .bottom,
                           relatedBy: .greaterThanOrEqual,
                           toItem: messagesCellTextView,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: textViewFrameInsets.bottom).isActive = true
        
        NSLayoutConstraint(item: messagesCellTextView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: bubbleContainerView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
    }
    
}
