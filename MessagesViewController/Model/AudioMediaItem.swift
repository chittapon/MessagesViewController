//
//  AudioMediaItem.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 27/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import UIKit
import AVKit

class AudioMediaItem: MediaItem {

    var audioData: Data
    var cachedMediaView: UIView!
    var playButton: UIButton!
    var progressView: UIProgressView!
    var progressTimer: Timer!
    var audioPlayer: AVAudioPlayer!
    var progressLabel: UILabel!
    
    init(audioData: Data) {
        self.audioData = audioData
        super.init(isOutgoing: true)
    }
    
    override func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        super.setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing)
        cachedMediaView = nil
    }
    
    override var mediaViewDisplaySize: CGSize {
        let controlInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 18)
        return CGSize(width: 160, height: controlInsets.top + controlInsets.bottom + #imageLiteral(resourceName: "play").size.height)
    }
    
    override var mediaView: UIView? {
        
        if self.cachedMediaView == nil {
            self.audioPlayer = try! AVAudioPlayer(data: self.audioData)
            self.audioPlayer.delegate = self
            
            let size = mediaViewDisplaySize
            let controlInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 18)
            
            // reverse the insets based on the message direction
            let leftInset: CGFloat, rightInset: CGFloat;
            if (self.appliesMediaViewMaskAsOutgoing) {
                leftInset = controlInsets.left;
                rightInset = controlInsets.right;
            } else {
                leftInset = controlInsets.right;
                rightInset = controlInsets.left;
            }
            
            // create container view for the various controls
            let playView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
            playView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            playView.contentMode = .center
            playView.clipsToBounds = true
            
            // create the play button
            let playButtonImage = #imageLiteral(resourceName: "play").imageMasked(with: UIColor.bubble_color_sent_default)
            let pauseButtonImage = #imageLiteral(resourceName: "pause").imageMasked(with: UIColor.bubble_color_sent_default)
            let buttonFrame = CGRect(x: leftInset, y: controlInsets.top, width: playButtonImage.size.width, height: playButtonImage.size.height)
            self.playButton = UIButton(frame: buttonFrame)
            self.playButton.setImage(playButtonImage, for: .normal)
            self.playButton.setImage(pauseButtonImage, for: .selected)
            self.playButton.addTarget(self, action: #selector(onPlayButton(_:)), for: .touchUpInside)
            playView.addSubview(self.playButton)
            
            // create a label to show the duration / elapsed time
            let durationString = self.timestampString(self.audioPlayer.duration, forDuration: self.audioPlayer.duration)
            let maxWidthString = "".padding(toLength: durationString.count, withPad: "0", startingAt: 0)
            
            var labelSize = CGSize(width: 36, height: 18)
            if durationString.count < 4 {
                labelSize = CGSize(width: 18, height: 18)
            }
            else if durationString.count < 5 {
                labelSize = CGSize(width: 24, height: 18)
            }
            else if durationString.count < 6 {
                labelSize = CGSize(width: 30, height: 18)
            }
            
            // this is cheesy, but it centers the progress bar without extra space and
            // without causing it to wiggle from side to side as the label text changes
            var labelFrame = CGRect(x: size.width - labelSize.width - rightInset, y: controlInsets.top, width: labelSize.width, height: labelSize.height)
            progressLabel = UILabel(frame: labelFrame)
            progressLabel.textAlignment = .left
            progressLabel.adjustsFontSizeToFitWidth = true
            progressLabel.textColor = UIColor.bubble_color_sent_default
            progressLabel.font = UIFont.preferredFont(forTextStyle: .body)
            progressLabel.text = maxWidthString
            
            // sizeToFit adjusts the frame's height to the font
            progressLabel.sizeToFit()
            labelFrame.origin.x = size.width - progressLabel.frame.size.width - rightInset
            labelFrame.origin.y = (size.height - progressLabel.frame.size.height) / 2
            labelFrame.size.width = progressLabel.frame.size.width
            labelFrame.size.height = progressLabel.frame.size.height
            progressLabel.frame = labelFrame
            progressLabel.text = durationString
            playView.addSubview(progressLabel)
            
            // create a progress bar
            let controlPadding: CGFloat = 6
            progressView = UIProgressView(progressViewStyle: .default)
            let xOffset: CGFloat = playButton.frame.origin.x + playButton.frame.size.width + controlPadding
            let width: CGFloat = labelFrame.origin.x - xOffset - controlPadding
            progressView.frame = CGRect(x: xOffset, y: (size.height - progressView.frame.size.height) / 2, width: width, height: progressView.frame.size.height)
            progressView.tintColor = UIColor.bubble_color_sent_default
            playView.addSubview(progressView)
            MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: playView, isOutgoing: appliesMediaViewMaskAsOutgoing)
            cachedMediaView = playView
        }
        return cachedMediaView
    }
    
    func timestampString(_ currentTime: TimeInterval, forDuration duration: TimeInterval) -> String {
        // print the time as 0:ss or ss.x up to 59 seconds
        // print the time as m:ss up to 59:59 seconds
        // print the time as h:mm:ss for anything longer
        if duration < 60 {
            if currentTime < duration {
                return String(format: "0:%02d", Int(round(currentTime)))
            }
            return String(format: "0:%02d", Int(ceil(currentTime)))
        }
        else if duration < 3600 {
            let min = currentTime/60
            let sec = Int(currentTime)%60
            return String(format: "%d:%02d", min, sec)
        }else {
            let hour = currentTime/3600
            let min = currentTime/60
            let sec = Int(currentTime)%60
            return String(format: "%d:%02d:%02d", hour, min, sec)
        }
    }
    
    @objc func onPlayButton(_ sender: UIButton){
        
        let category: String = AVAudioSessionCategoryPlayback
        let options: AVAudioSessionCategoryOptions = [.duckOthers, .defaultToSpeaker, .allowBluetooth]
        try? AVAudioSession.sharedInstance().setCategory(category, with: options)
        
        if audioPlayer.isPlaying {
            playButton.isSelected = false
            stopProgressTimer()
            audioPlayer.stop()
        }
        else {
            // fade the button from play to pause
            UIView.transition(with: playButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.playButton.isSelected = true
            }, completion: nil)
            startProgressTimer()
            audioPlayer.play()
        }
        
    }
    
    func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressTimer(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressTimer(_ sender: Timer) {
        if audioPlayer.isPlaying {
            progressView.progress = Float(audioPlayer.currentTime / audioPlayer.duration)
            progressLabel.text = timestampString(audioPlayer.currentTime, forDuration: audioPlayer.duration)
        }
    }
    
    func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}


extension AudioMediaItem: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopProgressTimer()
        progressView.progress = 1.0
        UIView.transition(with: cachedMediaView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.progressView.progress = 0
            self.playButton.isSelected = false
            self.progressLabel.text = self.timestampString(self.audioPlayer.duration, forDuration: self.audioPlayer.duration)
        }, completion: nil)
    }
}

//UIColor *tintColor = [UIColor jsq_messageBubbleBlueColor];
//AVAudioSessionCategoryOptions options = AVAudioSessionCategoryOptionDuckOthers
//    | AVAudioSessionCategoryOptionDefaultToSpeaker
//    | AVAudioSessionCategoryOptionAllowBluetooth;
//
//return [self initWithPlayButtonImage:[[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:tintColor]
//    pauseButtonImage:[[UIImage jsq_defaultPauseImage] jsq_imageMaskedWithColor:tintColor]
//    labelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
//    showFractionalSecodns:NO
//    backgroundColor:[UIColor jsq_messageBubbleLightGrayColor]
//    tintColor:tintColor
//    controlInsets:UIEdgeInsetsMake(6, 6, 6, 18)
//    controlPadding:6
//    audioCategory:@"AVAudioSessionCategoryPlayback"
//    audioCategoryOptions:options];

