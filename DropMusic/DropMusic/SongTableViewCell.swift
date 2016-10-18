//
//  SongTableViewCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/18/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    
    func updateCellWith(song: Song, at index: Int){
        self.trackNumberLabel.text = "\(index + 1)"
        self.songNameLabel.text = song.songName
    }
}
