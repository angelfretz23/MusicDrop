//
//  DropSongModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/18/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import MapKit
import CloudKit

class DropSong{
    
    let song: Song
    var postCoordinates: CLLocation
    let postedBy: String?
    let description: String?
    let postedDate: Date
    
    init(postCoordinates: CLLocation, song: Song, postedBy: String? = nil, description: String?, postedDate: Date = Date()){
        self.postCoordinates = postCoordinates
        self.song = song
        self.postedBy = postedBy
        self.description = description
        self.postedDate = postedDate
    }
    
    init?(cloudKitRecord: CKRecord){
        guard let postCoordinates = cloudKitRecord[DropSongKeys.postCoordinatesKey] as? CLLocation,
        let postedBy = cloudKitRecord[DropSongKeys.postedByKey] as? String?,
        let description = cloudKitRecord[DropSongKeys.descriptionKey] as? String?,
        let postedDate = cloudKitRecord[DropSongKeys.postedDateKey] as? Date,
            let songName = cloudKitRecord[SongKeys.songNameKey] as? String,
        let artistName = cloudKitRecord[SongKeys.artistNameKey] as? String,
        let storeID = cloudKitRecord[SongKeys.storeIDKey] as? String,
        let albumName = cloudKitRecord[SongKeys.albumName] as? String,
        let genre = cloudKitRecord[SongKeys.genreKey] as? String,
        let trackTime = cloudKitRecord[SongKeys.trackTimeKey] as? String?,
            let CollectionID = cloudKitRecord[SongKeys.collectionIDKey] as? String?, cloudKitRecord.recordType == DropSongKeys.recordType
            else { return nil }
        self.postCoordinates = postCoordinates
        self.postedBy = postedBy
        self.description = description
        self.postedDate = postedDate
        
        let song = Song(songName: songName, artistName: artistName, storeID: storeID, albumName: albumName, genre: genre, albumCover: nil, trackTime: trackTime, collectionID: CollectionID)
        
        self.song = song
    }
}
