//
//  ClusterView.swift
//  DropMusic
//
//  Created by Angel Contreras on 5/12/18.
//  Copyright © 2018 Angel Contreras. All rights reserved.
//

import MapKit

class ClusterView: MKMarkerAnnotationView {


    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .projectBlack
            glyphTintColor = .projectBlue
        }
    }
}
