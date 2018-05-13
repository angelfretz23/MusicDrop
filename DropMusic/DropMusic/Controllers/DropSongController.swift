//
//  DropSongController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/19/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import CoreLocation
import CoreGraphics

class DropSongController{
    
    static let shared = DropSongController()
    let cloudKitManager = CloudKitManager()
    
    var songAnnotations:[SongAnnotation] = []
    
    var tempSongAnnotations: [SongAnnotation] = []
    
    func post(dropSong: DropSong, addToCache: Bool = false, completion: @escaping ((Error?) -> Void) = { _ in }){
        let record = dropSong.cloudKitRecord
        
        cloudKitManager.saveRecord(record) { (_, error) in
            if let error = error{
                NSLog("Error saving \(dropSong) to CloudKit: \(error)")
                completion(error)
                return
            }
            completion(error)
        }
        let songAnnotation = SongAnnotation.songAnnotation(fromDropSong: dropSong)
        self.songAnnotations.append(songAnnotation)
        
        if addToCache {
            tempSongAnnotations.append(songAnnotation)
        }
    }

    
    func fetchDropSongs(completion: @escaping ((Error?) -> Void) = { _ in }){
        
        cloudKitManager.fetchRecordsWithType(DropSong.DropSongKeys.recordType) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error fetching messages: \(error)")
                return
            }
            guard let records = records else { return }
            let dropSongs = records.compactMap({ DropSong(cloudKitRecord: $0)})
            DispatchQueue.main.async {
                self.songAnnotations = SongAnnotation.songAnnotations(fromDropSongs: dropSongs)
            }
            completion(error)
        }
    }
    
    func fetchDropSongsWith(location: CLLocation, radiusInMeters: CGFloat, completion: @escaping (SongAnnotation) -> ()) {
        let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "PostCoordinate", location, radiusInMeters)
        cloudKitManager.fetchRecordsWithType(DropSong.DropSongKeys.recordType, predicate: locationPredicate, sortDescriptors: nil, recordFetchedBlock: { (record) in
            if let dropSong = DropSong(cloudKitRecord: record){
                let songAnnotation = SongAnnotation.songAnnotation(fromDropSong: dropSong)
                DispatchQueue.main.async {
                    if !self.songAnnotations.contains(songAnnotation) {
                        self.songAnnotations.append(songAnnotation)
                    }
                    completion(songAnnotation)
                }
            }
        }, completion: nil)
    }
}
