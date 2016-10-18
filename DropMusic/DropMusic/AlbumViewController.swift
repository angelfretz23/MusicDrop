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

    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let album = album {
            updateWith(album: album)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWith(album: Album){
        self.albumCoverImageView.image = album.albumCover
        self.albumNameLabel.text = album.albumName
        self.artistNameLabel.text = album.artistName
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = 
    }
}
