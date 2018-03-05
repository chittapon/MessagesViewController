//
//  MessagesViewController.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 10/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit
import Messages
import IGListKit
import CoreLocation
class MessagesViewController: UIViewController {

    @IBOutlet weak var inputTextView: CTTextView!
    @IBOutlet weak var toolbarContentView: UIView!
    @IBOutlet var inputToolbar: UIToolbar!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var avatarImages = ["1234": #imageLiteral(resourceName: "Brody-John-Wick")]
    
    let photoItem = PhotoMediaItem.init(isOutgoing: false)
    let locationItem = LocationMediaItem.init(location: CLLocation.init(latitude: 13.727286, longitude: 100.568995))
    let videoItem = VideoMediaItem.init(fileURL: URL.init(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    let audioItem = AudioMediaItem(audioData: try! Data.init(contentsOf: Bundle.main.url(forAuxiliaryExecutable: "jsq_messages_sample.m4a")!))
    
    lazy var messages: [Message] = [Message.init(isOutgoing: false, senderId: "1234", displayName: "pap", text: "Maecenas faucibus mollis interdum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.faucibus mollis interdum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.faucibus mollis interdum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
                               Message.init(isOutgoing: false, senderId: "1234", displayName: "1234", media: self.photoItem),
                               Message.init(isOutgoing: false, senderId: "1234", displayName: "1234", media: self.locationItem),
                               Message.init(isOutgoing: false, senderId: "1234", displayName: "1234", media: self.videoItem),
                               Message.init(isOutgoing: false, senderId: "1234", displayName: "1234", media: self.audioItem)]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: inputToolbar.bounds.height, right: 0)
        collectionView.contentInset = collectionInsets
        collectionView.scrollIndicatorInsets = collectionInsets
        collectionView.keyboardDismissMode = .interactive
        adapter.collectionView = collectionView
        adapter.dataSource = self
        toolbarContentView.translatesAutoresizingMaskIntoConstraints = false
        toolbarContentView.frame = inputToolbar.bounds
        sendButton.isEnabled = false
        inputToolbar.addSubview(toolbarContentView)
        inputToolbar.pinAllEdgesOfSubview(toolbarContentView)
        inputToolbar.setNeedsUpdateConstraints()
        inputToolbar.removeFromSuperview()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChangeNotification(notification:)), name: Notification.Name.UITextViewTextDidChange, object: inputTextView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationItem.setAppliesMediaViewMaskAsOutgoing(false)
        videoItem.setAppliesMediaViewMaskAsOutgoing(false)
        audioItem.setAppliesMediaViewMaskAsOutgoing(false)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.locationItem.setLocation(self.locationItem.location) {
                self.adapter.reloadData(completion: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.photoItem.image = #imageLiteral(resourceName: "Brody-John-Wick")
            self.adapter.reloadData(completion: nil)
        }
    }
    
    override var inputAccessoryView: UIView? {
        return inputToolbar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Notification
    
    @objc func keyboardWillChangeFrame(notification: Notification){
        
        guard let info = notification.userInfo else { return }
        let endframe = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let collectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: endframe.height, right: 0)
        collectionView.contentInset = collectionInsets
        collectionView.scrollIndicatorInsets = collectionInsets
    }
    
    @objc func textViewTextDidChangeNotification(notification: Notification) {
        sendButton.isEnabled = !inputTextView.text.isEmpty
    }
    
    // MARK: - Action

    @IBAction func sendMessage(_ sender: UIButton) {
        let message = Message(isOutgoing: true, senderId: "567", displayName: "pop", text: inputTextView.text)
        inputTextView.text = nil
        NotificationCenter.default.post(name: Notification.Name.UITextViewTextDidChange, object: inputTextView)
        
        messages.append(message)
        adapter.performUpdates(animated: false) { (_) in
            
            self.adapter.scroll(to: message, supplementaryKinds: nil, scrollDirection: .vertical, scrollPosition: .top, animated: true)
        }
    }
}

// MARK: ListAdapterDataSource

extension MessagesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return messages as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = MessagesSectionController()
        sectionController.avatarImageDataSource = self
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension MessagesViewController: MessageAvatarImageDataSource {
    
    func messagesSectionController(avatarImageWith object: Message) -> MessageAvatarImageData? {
        return MessagesAvatarImage(image: avatarImages[object.senderId])
    }
}
