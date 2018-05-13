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
    
    lazy var musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    let albumCoverImage: UIImageView = {
        let iv = UIImageView()
//        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
//        iv.roundCorners([.topLeft], radius: 3)
        return iv
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.projectBlue
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.projectBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let droppedByTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.projectBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var songAnnotation: SongAnnotation?{
        didSet{
            guard let dropSong = songAnnotation?.dropSong else { return }
            self.albumCoverImage.image = nil
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
        addSubview(albumCoverImage)
        addSubview(songTitleLabel)
        addSubview(artistTitleLabel)
        addSubview(droppedByTitleLabel)
        addSubview(descriptionTextView)
        
        // MARK: - Horizontal Constraints
        addConstraintsWithFormat(format: "H:|[v0(80)]-[v1]-|", views: albumCoverImage, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: artistTitleLabel, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: droppedByTitleLabel, artistTitleLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        
        // MARK: - Vertical Constraints
        addConstraintsWithFormat(format: "V:|[v0(80)]", views: albumCoverImage)
        addConstraintsWithFormat(format: "V:|-[v0(15)]-4-[v1(15)]-4-[v2(15)]", views: songTitleLabel, artistTitleLabel, droppedByTitleLabel)
        addConstraintsWithFormat(format: "V:[v0][v1]|", views: albumCoverImage, descriptionTextView)
        
        // Description View Height Constraint
//        descriptionViewHeightConstraint = NSLayoutConstraint(item: descriptionTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
//        addConstraint(descriptionViewHeightConstraint!)
    }
    
    override func setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
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
        

        ImageController.fetchImage(withString: dropSong.song.imageURL!, id: dropSong.song.storeID) { (image) in
            self.albumCoverImage.image = image
        }
    }
    
    @objc func play() {
        let storeID = songAnnotation?.dropSong?.song.storeID
        if let id = storeID {
            musicPlayer.setQueue(with: [id])
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }
}

