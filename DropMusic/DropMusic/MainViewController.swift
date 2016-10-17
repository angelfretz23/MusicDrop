//
//  MainViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/17/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var droppedByLabel: UILabel!
    @IBOutlet weak var discriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var annotationDetailView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        annotationDetailView.isHidden = true
    }

    @IBAction func itemButtonPressed(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5) {
            self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
            !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
        }
    }
    
    
}
