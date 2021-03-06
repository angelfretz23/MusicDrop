//
//  TopChartsTableViewCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit

class TopChartsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectinImage: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    func updateWith(song: Song, on index: Int){
        self.songNameLabel.text = song.songName
        self.artistNameLabel.text = song.artistName
        self.indexLabel.text = "\(index + 1)"
        collectinImage.image = nil
        ImageController.fetchImage(withString: song.imageURL!, id: song.storeID) { (image) in
            DispatchQueue.main.async {
                self.collectinImage.image = image
            }
        }
    }
}

