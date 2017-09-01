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
//    let coverImage: Data?
    
//    var temporaryPhotoURL: URL {
//        let temporaryDirectory = NSTemporaryDirectory()
//        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
//        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
////        try? coverImage?.write(to: fileURL, options: [.atomic])
//        return fileURL
//    }
    
    init(postCoordinates: CLLocation, song: Song, postedBy: String? = nil, description: String?, coverImage: Data? = nil, postedDate: Date = Date()){
        self.postCoordinates = postCoordinates
        self.song = song
        self.postedBy = postedBy
        self.description = description
        self.postedDate = postedDate
//        self.coverImage = coverImage
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
            let collectionID = cloudKitRecord[SongKeys.collectionIDKey] as? String?,
            var imageURL = cloudKitRecord[SongKeys.imageURLKey] as? String else { return nil }
//        ,
//            let photoAsset = cloudKitRecord[DropSongKeys.coverImageKey] as? CKAsset,
//            let coverImage = try? Data(contentsOf: photoAsset.fileURL), cloudKitRecord.recordType == DropSongKeys.recordType
//
        
        self.postCoordinates = postCoordinates
        self.postedBy = postedBy
        self.description = description
        self.postedDate = postedDate
//        self.coverImage = coverImage
        imageURL = imageURL.replacingOccurrences(of: "170", with: "500")
        imageURL = imageURL.replacingOccurrences(of: "100", with: "500")
        
        let song = Song(songName: songName, artistName: artistName, storeID: storeID, albumName: albumName, genre: genre, imageURL: imageURL, trackTime: trackTime, collectionID: collectionID)
        
        self.song = song
    }
}
