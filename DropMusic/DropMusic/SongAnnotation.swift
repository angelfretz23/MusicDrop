//
//  SongAnnotation.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/19/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import MapKit

class SongAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    let dropSong: DropSong?
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.dropSong = nil
    }
    
    init(dropSong: DropSong){
        self.coordinate = dropSong.postCoordinates.coordinate
        self.dropSong = dropSong
        self.title =  dropSong.song.songName
        self.subtitle = dropSong.song.artistName
        super.init()
    }

}
