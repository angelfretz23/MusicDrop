//
//  CloudKitManager.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/23/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitManager {
    
    let database = CKContainer.default().publicCloudDatabase
    
    func fetchRecords(ofType type: String,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        database.save(record, completionHandler: { (record, error) in
            completion(error)
        })
    }
}
