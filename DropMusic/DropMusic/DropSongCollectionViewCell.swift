//
//  DropSongCollectionViewCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/5/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class DropSongCollectionViewCell: BaseCell{
    
    let albumImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "theStage")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Stage"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Avenged Sevenfold"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let droppedByTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dropped by angelC"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "This is where i kissed my beautiful girl Chandi"
        textView.isEditable = false
        return textView
    }()
    
    override func setupViews() {
        addSubview(albumImageView)
        addSubview(songTitleLabel)
        addSubview(artistTitleLabel)
        addSubview(droppedByTitleLabel)
//        addSubview(descriptionTextView)
        
        addConstraintsWithFormat(format: "H:|[v0(80)]-[v1]-|", views: albumImageView, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: artistTitleLabel, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: droppedByTitleLabel, artistTitleLabel)
//        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: albumImageView)
        addConstraintsWithFormat(format: "V:|-[v0]-4-[v1]-4-[v2]", views: songTitleLabel, artistTitleLabel, droppedByTitleLabel)
//        addConstraintsWithFormat(format: "V:[v0]-[v1]-|", views: albumImageView, descriptionTextView)
    }
    
    final public func updateWith(dropSong:DropSong){
        songTitleLabel.text = dropSong.song.songName
        artistTitleLabel.text = dropSong.song.artistName
        droppedByTitleLabel.text = dropSong.postedBy ?? ""
        ImageController.fetchImage(withString: dropSong.song.imageURL!) { (image) in
            self.albumImageView.image = image
        }
    }
}

