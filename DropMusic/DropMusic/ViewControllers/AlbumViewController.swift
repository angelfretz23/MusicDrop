//
//  AlbumViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album?{
        didSet{
            tableView.reloadData()
            guard let album = album else { return }
            updateWith(album: album)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func updateWith(album: Album){
        self.albumNameLabel.text = album.albumName
        self.artistNameLabel.text = album.artistName
        self.copyrightLabel.text = album.copyrights
        let year = album.releaseDate?.components(separatedBy: "-").first
        self.yearLabel.text = year
        ImageController.fetchImage(withString: (album.imageURL)!) { (image) in
            self.albumCoverImageView.image = image
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songChosen"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                let dropSongVC = segue.destination as? DropSongViewController else { return }
            if let songs = album?.songs{
                let song = songs[indexPath.row]
                dropSongVC.song = song
            }
        }
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongTableViewCell
        
        guard let song = album?.songs?[indexPath.row] else { return UITableViewCell() }
        cell?.updateCellWith(song: song, at: indexPath.row)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Songs"
    }
}
