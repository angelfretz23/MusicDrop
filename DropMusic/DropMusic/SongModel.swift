//
//  SongModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit
/**
 Song class:
 A class containing all the necessary information to play a song from Apple Music.
 - Parameters:
 - songName: Name of the song track
 - artistName: Name of the song's artist
 - storeID: Apple iTunes Store ID (Store Protocol)
 - image170x170: Image data for album cover of 170x170 pixels
 - trackTime: Track time duration in milliseconds
 */

// TODO: Add streamable property
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
    var albumCover: UIImage?
    /// Track time duration in milliseconds
    let trackTime: String?
    
    let collectionID: String?
    
    var mediaType: String = "track"
    
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
    init(songName: String, artistSong: String, storeID: String,  trackTime: String? = nil, albumName: String, genre: String, albumCover: UIImage){
        self.songName = songName
        self.artistSong = artistSong
        self.storeID = storeID
        self.trackTime = trackTime
        self.albumName = albumName
        self.genre = genre
        self.albumCover = albumCover
        self.collectionID = nil
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
        
        self.collectionID = nil
        
        for imageDictionary in arrayOfImageDictionary {
            guard let urlString = imageDictionary["label"] as? String,
                let attributesDictionary = imageDictionary["attributes"] as? [String: Any],
                let height = attributesDictionary["height"] as? String else { return nil }
            switch height {
            case "170":
                ImageController.fetchImage(withString: urlString, completion: { (image) in
                    self.albumCover = image
                })
            default:()
            }
        }
    }
    
    init?(dictionaryItunesSearch: [String:Any]){
        if dictionaryItunesSearch["kind"] as? String == "music-video"{
            return nil
        }
        
        guard let songName = dictionaryItunesSearch["trackName"] as? String,
            let artistSong = dictionaryItunesSearch["artistName"] as? String,
            let storeID = dictionaryItunesSearch["trackId"] as? Double,
            let trackTime = dictionaryItunesSearch["trackTimeMillis"] as? Double,
            let albumName = dictionaryItunesSearch["collectionName"] as? String,
            let genre = dictionaryItunesSearch["primaryGenreName"] as? String,
            let largeImageURL = dictionaryItunesSearch["artworkUrl100"] as? String,
        let collectionID = dictionaryItunesSearch["collectionId"] as? Double else { return nil }
        let imageURLDictionary: [Int: String] = [100: largeImageURL]
        
        self.songName = songName
        self.artistSong = artistSong
        self.storeID = storeID.cleanValue
        self.trackTime = "\(trackTime)"
        self.albumName = albumName
        self.genre = genre
        self.collectionID = collectionID.cleanValue
        for imageURL in imageURLDictionary{
            ImageController.fetchImage(withString: imageURL.value, completion: { (image) in
                switch imageURL.key{
                case 100:
                    self.albumCover = image
                default:()
                }
            })
        }
    }
    
    func isEqualTo(other: StoreProtocol) -> Bool {
        guard let other = other as? Song else { return false }
        return self.storeID == other.storeID
    }
}
