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
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .white
        textView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        textView.isEditable = false
        return textView
    }()
    
    let circularProgress: KDCircularProgress = {
        let cp = KDCircularProgress()
        cp.glowAmount = 0.5
        cp.gradientRotateSpeed = 2
        cp.glowMode = .forward
        cp.translatesAutoresizingMaskIntoConstraints = false
        return cp
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        setupImageView()
        setupLabelsAndTextViews()
//        setupCircularProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
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
        
        
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: songTitleLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: artistNameLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: droppedByLabel)
        
        addConstraintsWithFormat(format: "V:|-[v0]-[v1(20)][v2(v1)][v3(v1)]", views: albumCoverImageView, songTitleLabel, artistNameLabel, droppedByLabel)
        
    }
    
    private func setupTextView(with string: String?){
        addSubview(descriptionTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "V:[v0][v1]-|", views: droppedByLabel, descriptionTextView)
        descriptionTextView.text = string
    }
    
    private func setupCircularProgress() {
        addSubview(circularProgress)
        let width = albumCoverImageView.frame.width / 3
        let height = albumCoverImageView.frame.width / 3
        let point = CGPoint(x: albumCoverImageView.center.x / 2, y: albumCoverImageView.center.y / 2)
        circularProgress.frame = CGRect(origin: point, size: CGSize(width: width, height: height))
        circularProgress.center = albumCoverImageView.center
    }
    
    public func update(with dropSong: DropSong) {
        songTitleLabel.text = dropSong.song.songName
        artistNameLabel.text = dropSong.song.artistName
        droppedByLabel.text = dropSong.postedBy ?? "Posted by Anonymous"
        setupTextView(with: dropSong.description)
        
        ImageController.fetchImage(withString: dropSong.song.imageURL!) { (image) in
            self.albumCoverImageView.image = image
        }
    }
}
