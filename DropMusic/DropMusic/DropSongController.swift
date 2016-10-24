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
    let cloudKitManager = CloudKitManager()
    
    var dropSongs:[DropSong] = []
    
    init(){
//        dummyDropSongs()
        fetchDropSongs()
    }
    
    func add(dropSong: DropSong){
        dropSongs.append(dropSong)
    }
    
    func post(dropSong: DropSong, completion: @escaping ((Error?) -> Void) = { _ in }){
        let record = dropSong.cloudKitRecord
        print(record)
        cloudKitManager.save(record) { (error) in
            if let error = error{
                NSLog("Error saving \(dropSong) to CloudKit: \(error)")
                completion(error)
                return
            }
            completion(error)
        }
        self.dropSongs.append(dropSong)
    }
    
    func fetchDropSongs(completion: @escaping ((Error?) -> Void) = { _ in }){
        let sortDescriptor = NSSortDescriptor(key: DropSong.DropSongKeys.recordType, ascending: false)
        
        cloudKitManager.fetchRecords(ofType: DropSong.DropSongKeys.recordType, sortDescriptors: [sortDescriptor]) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error fetching messages: \(error)")
                return
            }
            guard let records = records else { return }
            self.dropSongs = records.flatMap({DropSong(cloudKitRecord: $0)})
        }
    }
    
//    func dummyDropSongs(){
//        let song1 = Song(songName: "Requiem", artistSong: "Avenged Sevenfold", storeID: "672046425", albumName: "Hail to the King (Deluxe Version)", genre: "Rock", albumCover: #imageLiteral(resourceName: "requiem"))
//        let song2 = Song(songName: "The Stage", artistSong: "Avenged Sevenfold", storeID: "1161818185", albumName: "The Stage - Single", genre: "Rock", albumCover: #imageLiteral(resourceName: "theStage"))
//        let song3 = Song(songName: "We All Fall Down", artistSong: "Festive People", storeID: "1135100605", albumName: "Parade - EP", genre: "Pop", albumCover: #imageLiteral(resourceName: "festivePeople"))
//        let jimiSong = Song(songName: "Voodoo Child", artistSong: "The Jimi Hendrix Experience", storeID: "344800179", albumName: "Experience Hendrix: The Best of Jimi Hendrix", genre: "Rock", albumCover: #imageLiteral(resourceName: "voodoo child"))
//        
//        let dropSong1Location = CLLocation(latitude: 40.76181900, longitude: -111.89056100)
//        let dropsong1Description = "The intro to this songs just makes you feel awesome when looking down from my 78th floor office window."
//        let dropSOng1Poster = "BusinessMan1"
//        
//        let dropsong2Location = CLLocation(latitude: 40.76156016, longitude: -111.89076952)
//        let dropSong2Description = "Seeing people running up and down main street really makes me thing that we are just puppets in someone elses stage."
//        let dropSong2Poster = "360NoScoper"
//        
//        
//        let dropSong3Location = CLLocation(latitude: 40.76101500, longitude: -111.89162000)
//        
//        let blueNote = CLLocation(latitude: 40.73094200, longitude: -74.00065400)
//        
//        let jimiSongLocation = CLLocation(latitude: 40.73062100, longitude: -74.00093300)
//        let jimiSongDescription = "An iconic mainstay of Greenwich Village, Jimmy Hendrix used to play a few gigs here."
//        let jimiSongPoster = "QueenC"
//        
//        let dropSong1 = DropSong(postCoordinates: dropSong1Location, song: song1, postedBy: dropSOng1Poster, description: dropsong1Description, postedDate: Date())
//        let dropSong2 = DropSong(postCoordinates: dropsong2Location, song: song2, postedBy: dropSong2Poster, description: dropSong2Description, postedDate: Date())
//        let jimiDropSong = DropSong(postCoordinates: jimiSongLocation, song: jimiSong, postedBy: jimiSongPoster, description: jimiSongDescription, postedDate: Date())
//
//
//        dropSongs.append(contentsOf: [dropSong1, dropSong2, jimiDropSong])
//    }
}
