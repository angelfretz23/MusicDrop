//
//  DescriptionView.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/21/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

final class DescriptionView: UIView {
    
    // MARK: - Subviews
    private let whiteView = UIView()
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor().projectBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor().projectBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let droppedByLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor().projectBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .white
        textView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupLabelsAndTextViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        addSubview(albumCoverImageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: albumCoverImageView)
        addConstraintsWithFormat(format: "V:|[v0]", views: albumCoverImageView)
        
        let heightConstraint = NSLayoutConstraint(item: albumCoverImageView, attribute: .height, relatedBy: .equal, toItem: albumCoverImageView, attribute: .width, multiplier: 1.0, constant: 0)
        albumCoverImageView.addConstraint(heightConstraint)
        heightConstraint.isActive = true
    }
    
    private func setupLabelsAndTextViews() {
        addSubview(songTitleLabel)
        addSubview(artistNameLabel)
        addSubview(droppedByLabel)
        addSubview(descriptionTextView)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: songTitleLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: artistNameLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: droppedByLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "V:|-[v0][v1(20)][v2(v1)][v3(v1)][v4]-|", views: albumCoverImageView, songTitleLabel, artistNameLabel, droppedByLabel, descriptionTextView)
    }
    
    public func update(with dropSong: DropSong) {
        songTitleLabel.text = dropSong.song.songName
        artistNameLabel.text = dropSong.song.artistName
        droppedByLabel.text = dropSong.postedBy ?? "Posted by Anonymous"
        descriptionTextView.text = dropSong.description ?? ""
        let newImageURL = 
        ImageController.fetchImage(withString: dropSong.song.imageURL!) { (image) in
            self.albumCoverImageView.image = image
        }
    }
}
