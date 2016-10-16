//
//  ResultsTableViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/13/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit


class ResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var songs: [Song] = []{
        didSet{
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)

        let song = songs[indexPath.row]
        cell.textLabel?.text =  song.songName

        return cell
    }
}
