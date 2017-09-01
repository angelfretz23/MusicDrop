//
//  InfoView.swift
//  DropMusic
//
//  Created by Angel Contreras on 7/31/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class InfoView: UIView{
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(albumImageView)
        addSubview(songTitleLabel)
        addSubview(artistTitleLabel)
        addSubview(droppedByTitleLabel)
        addSubview(descriptionTextView)
        
        addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1]-|", views: albumImageView, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: artistTitleLabel, songTitleLabel)
        addConstraintsWithFormat(format: "H:[v0(v1)]-|", views: droppedByTitleLabel, artistTitleLabel)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "V:|-[v0(100)]", views: albumImageView)
        addConstraintsWithFormat(format: "V:|-[v0]-4-[v1]-4-[v2]", views: songTitleLabel, artistTitleLabel, droppedByTitleLabel)
        addConstraintsWithFormat(format: "V:[v0]-[v1]-|", views: albumImageView, descriptionTextView)
    }
}
