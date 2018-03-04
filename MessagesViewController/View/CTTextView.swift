//
//  CTTextView.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 15/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit

class CTTextView: UITextView {

    lazy var placeHolder = "Message here..."
    lazy var placeHolderColor = UIColor.gray
    lazy var placeHolderInsets = UIEdgeInsetsMake(8.0, 4.0, 8.0, 4.0)
    
    deinit {
        removeTextViewNotificationObservers()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.text.count == 0 {
            let placeHolderInsets = UIEdgeInsetsMake(8, 6, 8, 6)
            (placeHolder as NSString).draw(in: UIEdgeInsetsInsetRect(rect, placeHolderInsets), withAttributes: placeholderTextAttributes)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        autocorrectionType = .no
        clipsToBounds = true
        layer.cornerRadius = 6
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        textContainerInset = placeHolderInsets
        contentInset = UIEdgeInsetsMake(1, 0, 1, 0)
        font = UIFont.preferredFont(forTextStyle: .body)
        addTextViewNotificationObservers()
    }
    
    var placeholderTextAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font : self.font!,
                NSAttributedStringKey.foregroundColor : self.placeHolderColor]
    }
    
    private func addTextViewNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification), name: Notification.Name.UITextViewTextDidChange, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification), name: Notification.Name.UITextViewTextDidBeginEditing, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification), name: Notification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    private func removeTextViewNotificationObservers() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveTextViewNotification(notification: Notification) {
        setNeedsDisplay()
    }
}

