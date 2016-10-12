//
//  StoreProtocol.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/11/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
/**
    StoreProtocol to require each album and song objects to contain an Apple iTunes Store ID
 - Parameters:
 - storeID: Apple iTunes Store ID
 */
protocol StoreProtocol {
    var storeID: String { get }
}
