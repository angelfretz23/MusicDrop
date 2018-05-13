//
//  SongView.swift
//  DropMusic
//
//  Created by Angel Contreras on 5/12/18.
//  Copyright © 2018 Angel Contreras. All rights reserved.
//

import MapKit

class SongView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet{
            if let songAnnotation = newValue as? SongAnnotation, let song = songAnnotation.dropSong?.song {
                clusteringIdentifier = "DROPSONGS"
                glyphImage = #imageLiteral(resourceName: "drop")
                glyphTintColor = .projectBlue
                markerTintColor = .projectBlack
//                bounds.size = CGSize(width: 30, height: 30)
//                layer.shadowColor = UIColor.gray.cgColor
//                layer.shadowOpacity = 0.3
//                layer.shadowRadius = 5.0
//                layer.cornerRadius = 15
//                clipsToBounds = true
//                layer.shadowOffset = CGSize(width: 5, height: 5)
//                canShowCallout = false
            }
        }
    }
}

