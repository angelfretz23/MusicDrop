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
    
    var locationManager = CLLocationManager()
    var arrayOfDropSongs:[DropSong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotationDetailView.isHidden = true
        mapView.delegate = self

        createMOCAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticatePermissionToUseCurrentPostion()
    }
    
    @IBAction func itemButtonPressed(_ sender: AnyObject) {
        
    }
    
    func createMOCAnnotations(){
        for dropSong in DropSongController.sharedController.dropSongs {
            createAnnotationFrom(dropSong: dropSong)
        }
    }
}

extension MainViewController: MKMapViewDelegate{
    func authenticatePermissionToUseCurrentPostion(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location{
            centerMapOnLocation(location: location)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if annotationDetailView.isHidden && !(view.annotation?.isKind(of: MKUserLocation.self))!{
            UIView.animate(withDuration: 0.5) {
                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
            }
        }
        guard let annotation = view.annotation as? SongAnnotation else { return }
        
        albumCover.image = annotation.dropSong?.song.albumCover
        songNameLabel.text = annotation.dropSong?.song.songName
        artistNameLabel.text = annotation.dropSong?.song.artistSong
        albumNameLabel.text = annotation.dropSong?.song.albumName
        droppedByLabel.text = annotation.dropSong?.postedBy
        discriptionTextView.text = annotation.dropSong?.description
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if !annotationDetailView.isHidden{
            UIView.animate(withDuration: 0.5) {
                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 200
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotationFrom(dropSong: DropSong){
        let songAnnotation = SongAnnotation(dropSong: dropSong)
        mapView.addAnnotation(songAnnotation)
    }
    
}
