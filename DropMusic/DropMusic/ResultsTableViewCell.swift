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
    
    func updateWith(media: StoreProtocol){
        if media.mediaType == "track"{
            guard let song = media as? Song else { return }
            ImageController.fetchImage(withString: song.imageURL!, completion: { (image) in
                self.collectionImageView.image = image
            })
            titleLabel.text = song.songName
            artistNameLabel.text = song.artistName
        } else if media.mediaType == "collection"{
            guard let album = media as? Album else { return }
            collectionImageView.image = album.albumCover
            titleLabel.text = album.albumName
            artistNameLabel.text = album.artistName
        }
    }
    
}
