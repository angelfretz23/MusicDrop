//
//  TopChartsViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit

class TopChartsViewController: UIViewController {
    
    @IBOutlet weak var tableView1: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView1.delegate = self
        
        TopChartsController.fetchSongs { (songs) in
            DispatchQueue.main.async {
                self.songs = songs
            }
        }
    }
    
    var songs: [Song] = []{
        didSet{
            self.tableView1.reloadData()
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
        cell?.updateWith(song: song)
//        cell.textLabel?.text = song.songName
//        cell.detailTextLabel?.text = song.artistSong
        
        return cell ?? TopChartsTableViewCell()
    }
}
