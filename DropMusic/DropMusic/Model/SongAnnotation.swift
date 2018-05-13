//
//  SongAnnotation.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/19/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import MapKit

class SongAnnotation: MKPointAnnotation{
    
    var dropSong: DropSong?
    
    class func songAnnotations(fromDropSongs dropSongs: [DropSong]) -> [SongAnnotation] {
        let dSongs = dropSongs.map { (dropSong) -> SongAnnotation in
            let songAnnotation = SongAnnotation()
            songAnnotation.dropSong = dropSong
            songAnnotation.coordinate = dropSong.postCoordinates.coordinate
            songAnnotation.title = dropSong.song.songName
            songAnnotation.subtitle = dropSong.song.artistName
            return songAnnotation
        }
        return dSongs
    }
    
    class func songAnnotation(fromDropSong dropSong: DropSong) -> SongAnnotation {
        let songAnnotation = SongAnnotation()
        songAnnotation.dropSong = dropSong
        songAnnotation.coordinate = dropSong.postCoordinates.coordinate
        songAnnotation.title = dropSong.song.songName
        songAnnotation.subtitle = dropSong.song.artistName
        return songAnnotation
    }
}
