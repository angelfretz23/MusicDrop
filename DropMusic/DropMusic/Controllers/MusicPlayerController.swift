//
//  MusicPlayerController.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/21/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import MediaPlayer

protocol MusicPlayerControllerDelegate: class {
    func nowPlayingItemDidChange(albumCover: UIImage?, songTitle: String?, artistName: String?, id: String?)
    func playbackStateDidChange(playback: MPMusicPlaybackState)
}

final class MusicPlayerController {
    
    // MARK: - Private
    private let applicationMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    // MARK: - Public
//    public static let shared = MusicPlayerController()
    
    // MARK: - Init
    init() {
        applicationMusicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemChanged(_:)), name: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateChanged(_:)), name: Notification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    // MARK: - Delegate
    weak var delegate: MusicPlayerControllerDelegate?
    
    // MARK: - Playback State Enum
    
    public var playbackState: MPMusicPlaybackState {
        return applicationMusicPlayer.playbackState
    }
    
    // MARK: - Methods
    public func playSongWith(id string: String) {
        applicationMusicPlayer.setQueue(with: [string])
    }
    
    public func loadQueueWith(ids: [String], withFirstID firstID: String) {
        var idArray = ids
        idArray.insert(firstID, at: 0)
        applicationMusicPlayer.setQueue(with: idArray)
    }
    
    func play() {
        applicationMusicPlayer.prepareToPlay()
        applicationMusicPlayer.play()
    }
    
    @objc public func playPause() {
        if playbackState == .playing {
            applicationMusicPlayer.pause()
        } else {
            applicationMusicPlayer.play()
        }
    }
    
    @objc public func stop() {
        applicationMusicPlayer.stop()
    }
    
    @objc public func skip() {
        applicationMusicPlayer.skipToNextItem()
    }
    
    @objc public func previous() {
        if applicationMusicPlayer.currentPlaybackTime >= 5 {
            applicationMusicPlayer.skipToBeginning()
        } else {
            applicationMusicPlayer.skipToPreviousItem()
        }
    }
    
    public func fetchCurrentPlayItem() -> (UIImage?, String?, String?, String?) {
        var image: UIImage?
        var songTitle: String?
        var artistName: String?
        
        let currentPlayingItem = applicationMusicPlayer.nowPlayingItem
        image = currentPlayingItem?.artwork?.image(at: CGSize(width: 50, height: 50))
        songTitle = currentPlayingItem?.title
        artistName = currentPlayingItem?.artist
        
        let id = currentPlayingItem?.playbackStoreID
        if image == nil {
            image = ImageController.cache.object(forKey: NSString(string: id ?? ""))
        }
        
        return (image, songTitle, artistName, id)
    }
    
    @objc public func nowPlayingItemChanged(_ notification: Notification) {
        let currentItem = fetchCurrentPlayItem()
        delegate?.nowPlayingItemDidChange(albumCover: currentItem.0, songTitle: currentItem.1, artistName: currentItem.2, id: currentItem.3)
    }
    
    @objc public func playbackStateChanged(_ notification: Notification) {
        delegate?.playbackStateDidChange(playback: self.playbackState)
    }
}
