//
//  AlbumModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
/**
 Album class
 
 Parameter:
 - albumName: Name of the collection
 - releaseDate: Date of release
 - copyrights: Copyright information
 - storeID: Apple iTunes Store ID (Store Protocol)
 - songs: Array of songs objects
 */
class Album: StoreProtocol{
    /// Name of the collection
    let albumName: String
    /// Date of album release
    let releaseDate: Date
    /// Copyright information
    let copyrights: String
    /// Apple iTunes Store ID (Store Protocol)
    var storeID: String
    /// Array of songs objects
    let songs: [Song]

    
    init(albumName: String, releaseDate: Date, copyrights: String, storeID: String, songs: [Song]){
        self.albumName = albumName
        self.releaseDate = releaseDate
        self.copyrights = copyrights
        self.songs = songs
        self.storeID = storeID
    }
}
