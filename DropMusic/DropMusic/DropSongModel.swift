//
//  DropSongModel.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/18/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import MapKit

class DropSong{
    
    var postCoordinates: CLLocation
    let song: Song
    let postedBy: String?
    let description: String?
    let postedDate: Date
    
    init(postCoordinates: CLLocation, song: Song, postedBy: String? = nil, description: String?, postedDate: Date = Date()){
        self.postCoordinates = postCoordinates
        self.song = song
        self.postedBy = postedBy
        self.description = description
        self.postedDate = postedDate
    }
    
}
