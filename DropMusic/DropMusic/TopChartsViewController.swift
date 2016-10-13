//
//  TopChartsViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class TopChartsViewController: UIViewController {
    
    @IBOutlet weak var tableView1: UITableView!
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        
        TopChartsController.fetchSongs { (songs) in
            DispatchQueue.main.async {
                self.songs = songs
            }
        }
    }
    
    var songs: [Song] = []{
        didSet{
           tableView1.reloadData()
        }
    }
    
    @IBAction func fetchSongs(sender: UIBarButtonItem){
        
    }
}

extension TopChartsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topChartCell", for: indexPath) as? TopChartsTableViewCell
        
        let song = self.songs[indexPath.row]
        cell?.updateWith(song: song, on: indexPath.row)
        
        return cell ?? TopChartsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        print(song.storeID)
        playSongWithID(id: song.storeID)
    }
    
    func playSongWithID(id: String...){
        musicPlayer.setQueueWithStoreIDs(id)
        musicPlayer.play()
    }
}
