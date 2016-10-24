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
        static let storeIDKey = "StorerID"
        static let albumName = "AlbumName"
        static let genreKey = "Genre"
        static let collectionIDKey = "CollectionID"
        static let trackTimeKey = "TrackTime"
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
        record[DropSongKeys.postCoordinatesKey] = postCoordinates as CLLocation
        record[DropSongKeys.postedByKey] = postedBy as NSString?
        record[DropSongKeys.descriptionKey] = description as NSString?
        record[DropSongKeys.postedDateKey] = postedDate as NSDate
        
        record[SongKeys.songNameKey] = song.songName as NSString
        record[SongKeys.artistNameKey] = song.artistName as NSString
        record[SongKeys.storeIDKey] = song.storeID as NSString
        record[SongKeys.albumName] = song.albumName as NSString
        record[SongKeys.genreKey] = song.genre as NSString
        record[SongKeys.collectionIDKey] = song.collectionID as NSString?
        record[SongKeys.trackTimeKey] = song.trackTime as NSString?
        
        return record
    }
}
