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
        button.setImage(#imageLiteral(resourceName: "Previous"), for: .normal)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Skip"), for: .normal)
        return button
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        button.addTarget(self.musicPlayerController, action: #selector(self.musicPlayerController.playPause), for: .touchUpInside)
        return button
    }()
    
    lazy var albumCoverView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var currentlyPlayingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightThin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Currently Playing"
        return label
    }()
    
    lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().projectBlue
        label.text = "Song Title"
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().projectBlue
        label.text = "Artist Name"
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
        setupShadow()
        setupCurrentPlayingItem(currentPlayingItem: musicPlayerController.fetchCurrentPlayItem())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [previousButton, skipButton, playPauseButton, albumCoverView, songTitleLabel, artistNameLabel, currentlyPlayingLabel].forEach { (view) in
            addSubview(view)
        }
        
        addConstraintsWithFormat(format: "H:|-4-[v0(40)]", views: albumCoverView)
        addConstraintsWithFormat(format: "H:[v0(20)]-25-[v1(20)]-20-[v2(20)]-15-|", views: previousButton, playPauseButton, skipButton)
        
        albumCoverView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumCoverView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: previousButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: playPauseButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: skipButton)
        
        // Labels
        addConstraintsWithFormat(format: "H:[v0]-4-[v1][v2]", views: albumCoverView, currentlyPlayingLabel, previousButton)
        addConstraintsWithFormat(format: "H:[v0]-4-[v1][v2]", views: albumCoverView, songTitleLabel, previousButton)
        addConstraintsWithFormat(format: "H:[v0]-4-[v1][v2]", views: albumCoverView, artistNameLabel, previousButton)
        
        addConstraintsWithFormat(format: "V:|[v0][v1][v2]-4-|", views: currentlyPlayingLabel, songTitleLabel, artistNameLabel)
    }
    
    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        
    }
    
    private func setupCurrentPlayingItem(currentPlayingItem: (UIImage?, String?, String?)) {
        
    }
}

// MARK: - Music Player Controller Delegate
extension MusicPlayerView: MusicPlayerControllerDelegate {
    func nowPlayingItemDidChange(albumCover: UIImage?, songTitle: String?, artistName: String?) {
        if let albumCover = albumCover{
            albumCoverView.image = albumCover
        }
        songTitleLabel.text = songTitle
        artistNameLabel.text = artistName
    }
    
    func playbackStateDidChange(playback: MPMusicPlaybackState) {
        let setPlayPauseButtonImageToPlay: () = playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        switch playback {
        case .interrupted:
            setPlayPauseButtonImageToPlay
        case .paused:
            setPlayPauseButtonImageToPlay
        case .playing:
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        case .stopped:
            setPlayPauseButtonImageToPlay
        default:
            setPlayPauseButtonImageToPlay
        }
    }
}
