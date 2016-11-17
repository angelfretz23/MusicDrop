//
//  DropSong+CloudKit.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/22/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import CloudKit

extension DropSong{
    struct SongKeys{
        static let songNameKey = "SongName"
        static let artistNameKey = "ArtistName"
        static let storeIDKey = "StoreID"
        static let albumName = "AlbumName"
        static let genreKey = "Genre"
        static let collectionIDKey = "CollectionID"
        static let trackTimeKey = "TrackTime"
        static let imageURLKey = "ImageURL"
    }
    
    struct DropSongKeys{
        static let recordType = "DropSong"
        static let postCoordinatesKey = "PostCoordinate"
        static let postedByKey = "PostedBy"
        static let descriptionKey = "Description"
        static let postedDateKey = "PostedDate"
    }
    
    var cloudKitRecord: CKRecord{
        let record = CKRecord(recordType: DropSongKeys.recordType)
        
        record.setValue(postCoordinates, forKey: DropSongKeys.postCoordinatesKey)
        record.setValue(postedBy, forKey: DropSongKeys.postedByKey)
        record.setValue(description, forKey: DropSongKeys.descriptionKey)
        record.setValue(postedDate, forKey: DropSongKeys.postedDateKey)
        
        record.setValue(song.songName, forKey: SongKeys.songNameKey)
        record.setValue(song.artistName, forKey: SongKeys.artistNameKey)
        record.setValue(song.storeID, forKey: SongKeys.storeIDKey)
        record.setValue(song.albumName, forKey: SongKeys.albumName)
        record.setValue(song.genre, forKey: SongKeys.genreKey)
        record.setValue(song.collectionID, forKey: SongKeys.collectionIDKey)
        record.setValue(song.trackTime, forKey: SongKeys.trackTimeKey)
        record.setValue(song.imageURL, forKey: SongKeys.imageURLKey)
         
        return record
    }
}
