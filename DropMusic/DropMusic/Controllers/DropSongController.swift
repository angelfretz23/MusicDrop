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
    
    var songAnnotations:[SongAnnotation] = []{
        didSet{
            let notificationName = Notification.Name(rawValue: "newDropSongAdded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func post(dropSong: DropSong, completion: @escaping ((Error?) -> Void) = { _ in }){
        let record = dropSong.cloudKitRecord
        
        cloudKitManager.saveRecord(record) { (_, error) in
            if let error = error{
                NSLog("Error saving \(dropSong) to CloudKit: \(error)")
                completion(error)
                return
            }
            completion(error)
        }
        let songAnnotation = SongAnnotation(dropSong: dropSong)
        self.songAnnotations.append(songAnnotation)
    }

    
    func fetchDropSongs(completion: @escaping ((Error?) -> Void) = { _ in }){
        
        cloudKitManager.fetchRecordsWithType(DropSong.DropSongKeys.recordType) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error fetching messages: \(error)")
                return
            }
            guard let records = records else { return }
            DispatchQueue.main.async {
                let dropSongs = records.flatMap({ DropSong(cloudKitRecord: $0)})
                dropSongs.forEach({ (dropSong) in
                    self.songAnnotations.append(SongAnnotation(dropSong: dropSong))
                })
            }
            completion(error)
        }
    }
    
    func fetchDropSongsWith(location: CLLocation, radiusInMeters: CGFloat, completion: @escaping (SongAnnotation) -> ()) {
        let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "PostCoordinate", location, radiusInMeters)
        cloudKitManager.fetchRecordsWithType(DropSong.DropSongKeys.recordType, predicate: locationPredicate, sortDescriptors: nil, recordFetchedBlock: { (record) in
            if let dropSong = DropSong(cloudKitRecord: record){
                completion(SongAnnotation(dropSong: dropSong))
            }
        }, completion: nil)
    }
}
