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
    
    var dropSongs:[DropSong] = []{
        didSet{
            let notificationName = Notification.Name(rawValue: "newDropSongAdded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    init(){
    }
    
    func post(dropSong: DropSong, completion: @escaping ((Error?) -> Void) = { _ in }){
        let record = dropSong.cloudKitRecord
        
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
        
        cloudKitManager.fetchRecords(ofType: DropSong.DropSongKeys.recordType, sortDescriptors: nil) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error fetching messages: \(error)")
                return
            }
            guard let records = records else { return }
            DispatchQueue.main.async {
                self.dropSongs = records.flatMap({DropSong(cloudKitRecord: $0)})
            }
            completion(error)
        }
    }
}
