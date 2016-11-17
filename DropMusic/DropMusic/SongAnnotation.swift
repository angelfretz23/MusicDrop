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
//    var annotationImage:UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.dropSong = nil
    }
    
    init(dropSong: DropSong){
        self.coordinate = dropSong.postCoordinates.coordinate
        self.dropSong = dropSong
        super.init()
    }
    
//    func makeAnnotationImage(){
//        ImageController.fetchImage(withString: (dropSong?.song.imageURL)!) { (image) in
//            ImageController.getNewAnnotation(albumCover: image?.circle, completion: { (annotationImage) in
//                self.annotationImage = annotationImage
//            })
//        }
//    }
}
