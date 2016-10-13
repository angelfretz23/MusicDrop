//
//  SongModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
/**
 Song class:
 A class containing all the necessary information to play a song from Apple Music.
 - Parameters:
 - songName: Name of the song track
 - artistName: Name of the song's artist
 - storeID: Apple iTunes Store ID (Store Protocol)
 - image55x55: Image data for album cover of 55x55 pixels
 - image170x170: Image data for album cover of 170x170 pixels
 - trackTime: Track time duration in milliseconds
 */
class Song: StoreProtocol {
    /// Name of the song track
    let songName: String
    /// Name of the song's artist
    let artistSong: String
    /// Apple iTunes Store ID (Store Protocol)
    var storeID: String
    /// Name of the album in which the song pertains to
    let albumName: String
    /// Music Genre
    let genre: String
    
//let albumCoverSet: AlbumCoverCollection?
    var smallImage: String = ""
    var mediumImage: String = ""
    var largeImage: String? = ""
    /// Track time duration in milliseconds
    let trackTime: String
    
    struct keys{
        static let kSongName = "label"
        static let kArtistSong = "label"
        static let kStoreID = "im:id"
        static let kAlbumName = "label"
        static let kAlbumCoverSet = "image"
        static let kTrackTime = "label"
        static let kGenre = "label"
    }
    
    /// Initialize with songName, artistSong, storeID, Images, and TrackTime.
    init(songName: String, artistSong: String, storeID: String,  trackTime: String, albumName: String, genre: String){
        self.songName = songName
        self.artistSong = artistSong
        self.storeID = storeID
//self.albumCoverSet = albumCoverSet
        self.trackTime = trackTime
        self.albumName = albumName
        self.genre = genre
    }
    
    init?(dictionaryTopCharts: [String: Any]){
        guard let songNameDictionary = dictionaryTopCharts["im:name"] as? [String: String],
            let artistDictionary = dictionaryTopCharts["im:artist"] as? [String: Any],
            let arrayOfImageDictionary = dictionaryTopCharts["im:image"] as? [[String: Any]],
            let albumNameDictionary = dictionaryTopCharts["im:collection"] as? [String: Any],
            let trackTimeArrayOfDictionaries = dictionaryTopCharts["link"] as? [[String: Any]],
            let idDictionary = dictionaryTopCharts["id"] as? [String: Any],
            let genreDictionary = dictionaryTopCharts["category"] as? [String: Any] else { return nil }
        
        self.songName = songNameDictionary[keys.kSongName]!
        self.artistSong = artistDictionary[keys.kArtistSong] as! String
        
        guard let storeIDDictionary = idDictionary["attributes"] as? [String: String] else { return nil }
        self.storeID = storeIDDictionary[keys.kStoreID]!
        
        guard let collectionNameDictionary = albumNameDictionary["im:name"] as? [String: String] else { return nil }
        self.albumName = collectionNameDictionary[keys.kAlbumName]!
        
        let lastArrayValue = trackTimeArrayOfDictionaries.last
        let durationDictionary = lastArrayValue?["im:duration"] as? [String: String]
        self.trackTime = (durationDictionary?[keys.kTrackTime])!
        
        let attributesDictinary = genreDictionary["attributes"] as? [String: String]
        self.genre = (attributesDictinary?[keys.kGenre])!
        
        
        for imageDictionary in arrayOfImageDictionary {
            guard let url = imageDictionary["label"] as? String,
                let attributesDictionary = imageDictionary["attributes"] as? [String: Any],
                let height = attributesDictionary["height"] as? String else { return nil }
            
            switch height {
            case "55":
                self.smallImage = url
            case "60":
                self.mediumImage = url
            case "170":
                self.largeImage = url
            default:
                return nil
            }
        }
    }
}
