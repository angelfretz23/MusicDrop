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
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var songs: [StoreProtocol] = []
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return songs.filter{$0.mediaType == "track"}.count
        } else {
            return songs.filter{$0.mediaType == "collection"}.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultsTableViewCell
        // TODO: Figure out why app crashes when cancel is clicked
        let index = (indexPath.section * songs.filter{$0.mediaType == "track"}.count) + indexPath.row
        let media = songs[index]
        cell?.updateWith(media: media)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let index = (indexPath.section * songs.filter{$0.mediaType == "track"}.count) + indexPath.row
        let media = songs[index]
        if media.mediaType ==  "track"{
            self.presentingViewController?.performSegue(withIdentifier: "mediaSelectedFromSearchController", sender: cell)
        } else if media.mediaType == "collection"{
            self.presentingViewController?.performSegue(withIdentifier: "albumDetailFromSearchController", sender: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Songs"
        } else {
            return "Albums"
        }
    }
    
    func playSongWith(ids: String...){
        mediaPlayer.setQueue(with: ids)
        mediaPlayer.play()
    }
}
