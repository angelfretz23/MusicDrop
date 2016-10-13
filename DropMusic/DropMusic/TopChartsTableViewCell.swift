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
        self.artistNameLabel.text = song.artistSong
        self.indexLabel.text = "\(index + 1)"
        
        guard let url = URL(string: song.mediumImage),
            let data = (try? Data(contentsOf: url)) else { return }
        collectinImage.image = UIImage(data: data)
    }
    
}
