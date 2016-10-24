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
    let releaseDate: String?
    /// Artist Name of the album
    let artistName: String
    /// Copyright information
    let copyrights: String?
    /// Apple iTunes Store ID (Store Protocol)
    var storeID: String
    /// Album Cover
    var albumCover: UIImage?
    /// Array of songs objects
    var songs: [Song]?
    
    var mediaType: String = "collection"

    init(withSong song: Song){
        self.albumName = song.albumName
        self.artistName = song.artistName
        self.releaseDate = nil
        self.copyrights = nil
        self.songs = nil
        self.albumCover = song.albumCover ?? UIImage()
        guard let collectionID = song.collectionID else {self.storeID = ""; return}
        self.storeID = collectionID
    }
    
    init?(dictionary: [String: Any]){
        guard let albumName = dictionary["collectionName"] as? String,
        let releaseDate = dictionary["releaseDate"] as? String,
        let artistName = dictionary["artistName"] as? String,
        let copyrights = dictionary["copyright"] as? String,
        let storeID = dictionary["collectionId"] as? Double,
        let albumCoverURL = dictionary["artworkUrl100"] as? String
            else { return nil }
        self.albumName = albumName
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.copyrights = copyrights
        self.storeID = storeID.cleanValue
        self.songs = []
        
        ImageController.fetchImage(withString: albumCoverURL) { (image) in
            let image = image ?? UIImage()
            self.albumCover = image
        }
    }
    
    func isEqualTo(other: StoreProtocol) -> Bool {
        guard let other = other as? Album else { return false }
        return self.storeID == other.storeID
    }
}

func ==(left: Album, right: Album) -> Bool{
    return left.storeID == right.storeID
}
