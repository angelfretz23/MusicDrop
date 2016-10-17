//
//  AlbumModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit
/**
 Album class
 
 Parameter:
 - albumName: Name of the collection
 - releaseDate: Date of release
 - copyrights: Copyright information
 - storeID: Apple iTunes Store ID (Store Protocol)
 - songs: Array of songs objects
 */
class Album: StoreProtocol, Equatable{
    /// Name of the collection
    let albumName: String
    /// Date of album release
    let releaseDate: Date?
    /// Artist Name of the album
    let artistName: String
    /// Copyright information
    let copyrights: String?
    /// Apple iTunes Store ID (Store Protocol)
    var storeID: String
    /// Album Cover
    let albumCover: UIImage?
    /// Array of songs objects
    let songs: [Song]?
    
    var mediaType: String = "collection"

    
//    init(albumName: String, artistName: String, storeID: String, songs: [Song]? = nil, releaseDate: Date? = nil, copyrights: String? = nil){
//        self.albumName = albumName
//        self.artistName = artistName
//        self.releaseDate = releaseDate
//        self.copyrights = copyrights
//        self.songs = songs
//        self.storeID = storeID
//    }
    
    init(withSong song: Song){
        self.albumName = song.albumName
        self.artistName = song.artistSong
        self.releaseDate = nil
        self.copyrights = nil
        self.songs = nil
        self.albumCover = song.mediumImage!
        guard let collectionID = song.collectionID else {self.storeID = ""; return}
        self.storeID = collectionID
    }
    
    func isEqualTo(other: StoreProtocol) -> Bool {
        guard let other = other as? Album else { return false }
        return self.storeID == other.storeID
    }
}

func ==(left: Album, right: Album) -> Bool{
    return left.storeID == right.storeID
}
