//
//  MusicPlayerView.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/15/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicPlayerView: UIView{
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self.musicPlayerController, action: #selector(self.musicPlayerController.previous), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Previous").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .projectBlue
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self.musicPlayerController, action: #selector(self.musicPlayerController.skip), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "Skip").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .projectBlue
        return button
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Play").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .projectBlue
        button.addTarget(self.musicPlayerController, action: #selector(self.musicPlayerController.playPause), for: .touchUpInside)
        return button
    }()
    
    lazy var albumCoverView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var songDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var musicPlayerController: MusicPlayerController = {
        let mPC = MusicPlayerController()
        mPC.delegate = self
        return mPC
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
//        setupShadow()
        setupCurrentPlayingItem(currentPlayingItem: musicPlayerController.fetchCurrentPlayItem())
        skipButton.isHidden = true
        previousButton.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [previousButton, skipButton, playPauseButton, albumCoverView, songDetailLabel].forEach { (view) in
            addSubview(view)
        }
        
        addConstraintsWithFormat(format: "H:|[v0(68)]", views: albumCoverView)
        addConstraintsWithFormat(format: "H:[v0(20)]-25-[v1(20)]-20-[v2(20)]-15-|", views: previousButton, playPauseButton, skipButton)
        
        
        albumCoverView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumCoverView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: previousButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: playPauseButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: skipButton)
        
        
        // Labels
        addConstraintsWithFormat(format: "H:[v0]-4-[v1]-4-[v2]", views: albumCoverView, songDetailLabel, previousButton)
        
        addConstraintsWithFormat(format: "V:[v0]-4-|", views: songDetailLabel)
    }
    
    enum PlayingState {
        case noItemCurrentlyPlaying
        case currentlyPlaying
        case paused
    }
    
    func updatePlayerWith(playingState: PlayingState) {
        var bool: Bool!
        switch playingState {
        case .noItemCurrentlyPlaying:
            bool = true
        case .currentlyPlaying, .paused:
            bool = false
        }
        albumCoverView.isHidden = bool
        songDetailLabel.isHidden = bool
    }
    
    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        
    }
    
    private func setupCurrentPlayingItem(currentPlayingItem: (UIImage?, String?, String?, String?)) {
        if currentPlayingItem.0 == nil, currentPlayingItem.1 == nil, currentPlayingItem.2 == nil {
            updatePlayerWith(playingState: .noItemCurrentlyPlaying)
        }
    }
}

// MARK: - Music Player Controller Delegate
extension MusicPlayerView: MusicPlayerControllerDelegate {
    func nowPlayingItemDidChange(albumCover: UIImage?, songTitle: String?, artistName: String?, id: String?) {
        if let albumCover = albumCover{
            albumCoverView.image = albumCover
        } else {
            let song = DropSongController.shared.songAnnotations.filter{ $0.dropSong?.song.storeID == id }.compactMap{$0.dropSong?.song}.first
            guard let realSong = song else { return }
            ImageController.fetchImage(withString: realSong.imageURL ?? "", with: 50, id: id) { (img) in
                DispatchQueue.main.async {
                    self.albumCoverView.image = img
                }
            }
        }
        let songDetailsString = "\(songTitle ?? "")\n\(artistName ?? "")"
        let attributedString = NSMutableAttributedString(string: songDetailsString)
        let range = attributedString.mutableString.range(of: artistName ?? "", options: .caseInsensitive)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.projectBlue, range: range)
        songDetailLabel.attributedText = attributedString
    }
    
    func playbackStateDidChange(playback: MPMusicPlaybackState) {
        let setPlayPauseButtonImageToPlay: () = playPauseButton.setImage(#imageLiteral(resourceName: "Play").withRenderingMode(.alwaysTemplate), for: .normal)
        switch playback {
        case .interrupted:
            setPlayPauseButtonImageToPlay
        case .paused:
            setPlayPauseButtonImageToPlay
        case .playing:
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause").withRenderingMode(.alwaysTemplate), for: .normal)
        case .stopped:
            setPlayPauseButtonImageToPlay
        default:
            setPlayPauseButtonImageToPlay
        }
    }
}
