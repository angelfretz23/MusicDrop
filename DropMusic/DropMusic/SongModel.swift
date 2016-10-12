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
    
    let albumCoverSet: AlbumCoverCollection
    /// Track time duration in milliseconds
    let trackTime: Double
    
    /// Initialize with songName, artistSong, storeID, Images, and TrackTime.
    init(songName: String, artistSong: String, storeID: String, albumCoverSet: AlbumCoverCollection , trackTime: Double, albumName: String, genre: String){
        self.songName = songName
        self.artistSong = artistSong
        self.storeID = storeID
        self.albumCoverSet = albumCoverSet
        self.trackTime = trackTime
        self.albumName = albumName
        self.genre = genre
    }
}
