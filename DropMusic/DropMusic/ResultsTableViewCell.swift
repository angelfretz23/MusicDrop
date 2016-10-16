//
//  ResultsTableViewCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/13/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    func updateWith(song: Song){
        collectionImageView.image = song.mediumImage
        titleLabel.text = song.songName
        artistNameLabel.text = song.artistSong
    }

}
