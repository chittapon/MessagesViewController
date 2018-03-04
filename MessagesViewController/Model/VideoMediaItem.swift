//
//  VideoMediaItem.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 27/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoMediaItem: MediaItem {
    
    var fileURL: URL
    var thumbnailImage: UIImage? { return thumnailForVideo() }
    var cachedVideoImageView: UIImageView!
    var playButton: UIButton!
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(isOutgoing: true)
    }
    
    private func thumnailForVideo() -> UIImage? {
        
//        let asset = AVAsset(url: fileURL)
//        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
//        var time = asset.duration
//        time.value = CMTimeValue(min(Double(time.value), 2.0))
//        do {
//            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
//            return UIImage(cgImage: imageRef)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        return nil
        
        return #imageLiteral(resourceName: "Brody-John-Wick")
    }
    
    override func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        super.setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing)
        cachedVideoImageView = nil
    }
    
    override var mediaView: UIView? {

        if cachedVideoImageView == nil {
            let size: CGSize = mediaViewDisplaySize
            let playIcon = #imageLiteral(resourceName: "play").imageMasked(with: .lightGray)
            self.playButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: size))
            self.playButton.isUserInteractionEnabled = true
            self.playButton.setTitle(nil, for: .normal)
            self.playButton.addTarget(self, action: #selector(onPlayButton(_:)), for: .touchUpInside)
            
            let imageView = UIImageView(image: playIcon)
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            
            MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: imageView, isOutgoing: appliesMediaViewMaskAsOutgoing)
            
            if let thumbnailImage = thumbnailImage{
                let thumbnailImageView = UIImageView(image: thumbnailImage)
                thumbnailImageView.frame = CGRect(origin: CGPoint.zero, size: size)
                thumbnailImageView.contentMode = .scaleAspectFill
                thumbnailImageView.clipsToBounds = true
                MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: thumbnailImageView, isOutgoing: appliesMediaViewMaskAsOutgoing)
                imageView.backgroundColor = UIColor.clear
                thumbnailImageView.addSubview(imageView)
                cachedVideoImageView = thumbnailImageView
            }
            else {
                imageView.backgroundColor = UIColor.black
                cachedVideoImageView = imageView
            }
            cachedVideoImageView.isUserInteractionEnabled = true
            cachedVideoImageView.addSubview(playButton)
        }
        return cachedVideoImageView
        
    }
    
    @objc func onPlayButton(_ sender: UIButton) {
        
//        let player = AVPlayer(url: self.fileURL)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRect(origin: CGPoint.zero, size: self.mediaViewDisplaySize)
//        playerLayer.backgroundColor = UIColor.black.cgColor
//        self.cachedVideoImageView.layer.addSublayer(playerLayer)
//        player.play()
    }
}
