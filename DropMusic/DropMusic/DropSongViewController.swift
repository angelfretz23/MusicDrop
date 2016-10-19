//
//  DropSongViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/16/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import MapKit
import StoreKit
import MediaPlayer

class DropSongViewController: UIViewController {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var song: Song?
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let song = song{
            updateWith(song: song)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        guard let storeID = song?.storeID else { return }
        playSongWith(id: storeID)
    }
    
    func playSongWith(id: String...){
        mediaPlayer.setQueueWithStoreIDs(id)
        print()
        mediaPlayer.play()
    }
    
    func updateWith(song: Song){
        albumCover.image = song.albumCover
        songNameLabel.text = song.songName
        artistNameLabel.text = song.artistSong
        albumNameLabel.text = song.albumName
    }
}
