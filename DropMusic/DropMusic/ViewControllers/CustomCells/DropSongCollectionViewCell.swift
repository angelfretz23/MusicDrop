//
//  DropSongCollectionViewCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/5/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import MediaPlayer

class DropSongCollectionViewCell: BaseCell{
    
    lazy var musicPlayer = MPMusicPlayerController()
    
    let albumCoverButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor().projectBlue
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor().projectBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let droppedByTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor().projectBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var songAnnotation: SongAnnotation?{
        didSet{
            guard let dropSong = songAnnotation?.dropSong else { return }
            self.albumCoverButton.setImage(nil, for: .normal)
            updateWith(dropSong: dropSong)
        }
    }
    
//    var descriptionViewHeightConstraint: NSLayoutConstraint?
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .center
        return textView
    }()
    
    override func setupViews() {
        addSubview(albumCoverButton)
        addSubview(songTitleLabel)
        addSubview(artistTitleLabel)
        addSubview(droppedByTitleLabel)
        addSubview(descriptionTextView)
        
        // MARK: - Horizontal Constraints
        addConstraintsWithFormat(format: "H:|[v0(80)]-[v1]-|", views: albumCoverButton, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: artistTitleLabel, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: droppedByTitleLabel, artistTitleLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        
        // MARK: - Vertical Constraints
        addConstraintsWithFormat(format: "V:|[v0(80)]", views: albumCoverButton)
        addConstraintsWithFormat(format: "V:|-[v0(15)]-4-[v1(15)]-4-[v2(15)]", views: songTitleLabel, artistTitleLabel, droppedByTitleLabel)
        addConstraintsWithFormat(format: "V:[v0][v1]|", views: albumCoverButton, descriptionTextView)
        
        // Description View Height Constraint
//        descriptionViewHeightConstraint = NSLayoutConstraint(item: descriptionTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
//        addConstraint(descriptionViewHeightConstraint!)
    }
    
    private func updateWith(dropSong:DropSong){
        songTitleLabel.text = dropSong.song.songName
        artistTitleLabel.text = dropSong.song.artistName
        droppedByTitleLabel.text = "Dropped by \(dropSong.postedBy ?? "Anonymous")"
        
        if let descrip = dropSong.description, descrip != "" {
            descriptionTextView.text = descrip
        } else {
            descriptionTextView.text = "No Description"
        }
        

        ImageController.fetchImage(withString: dropSong.song.imageURL!) { (image) in
            self.albumCoverButton.setImage(image, for: .normal)
        }
    }
    
    @objc func play() {
        let storeID = songAnnotation?.dropSong?.song.storeID
        if let id = storeID {
            musicPlayer.setQueueWithStoreIDs([id])
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }
}

