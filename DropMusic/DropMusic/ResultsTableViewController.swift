//
//  ResultsTableViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/13/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class ResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var songs: [Song] = []{
        didSet{
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultsTableViewCell

        let song = songs[indexPath.row]
        cell?.updateWith(song: song)

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.presentingViewController?.performSegue(withIdentifier: "mediaSelectedFromSearchController", sender: cell)
    }
    
    func playSongWith(ids: String...){
        mediaPlayer.setQueueWithStoreIDs(ids)
        mediaPlayer.play()
    }
}
