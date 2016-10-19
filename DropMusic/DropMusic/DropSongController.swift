//
//  DropSongController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/19/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import MapKit

class DropSongController{
    
    static let sharedController = DropSongController()
    
    var dropSongs:[DropSong] = []
    
    init(){
        dummyDropSongs()
    }
    
    func add(dropSong: DropSong){
        dropSongs.append(dropSong)
    }
    
    func dummyDropSongs(){
        let song1 = Song(songName: "Requiem", artistSong: "Avenged Sevenfold", storeID: "672046425", albumName: "Hail to the King (Deluxe Version)", genre: "Rock", albumCover: #imageLiteral(resourceName: "requiem"))
        let song2 = Song(songName: "The Stage", artistSong: "Avenged Sevenfold", storeID: "1161818185", albumName: "The Stage - Single", genre: "Rock", albumCover: #imageLiteral(resourceName: "theStage"))
        let song3 = Song(songName: "We All Fall Down", artistSong: "Festive People", storeID: "1135100605", albumName: "Parade - EP", genre: "Pop", albumCover: #imageLiteral(resourceName: "festivePeople"))
        
        let dropSong1Location = CLLocation(latitude: 40.76181900, longitude: -111.89056100)
        let dropsong1Description = "The intro to this songs just makes you feel awesome when looking down from my 78th floor office window."
        let dropSOng1Poster = "BusinessMan1"
        
        let dropSong1 = DropSong(postCoordinates: dropSong1Location, song: song1, postedBy: dropSOng1Poster, description: dropsong1Description, postedDate: Date())
        dropSongs.append(dropSong1)
    }
}
