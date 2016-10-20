//
//  MainViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/17/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer
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
    var updated = false
    
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var songID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotationDetailView.isHidden = true
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticatePermissionToUseCurrentPostion()
        createMOCAnnotations()
    }
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let songID = self.songID else { return }
        musicPlayer.setQueueWithStoreIDs([songID])
        musicPlayer.play()
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
        if !updated{
            guard let location = userLocation.location else { return }
            centerMapOnLocation(location: location)
            updated = true
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
        songID = annotation.dropSong?.song.storeID
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if !annotationDetailView.isHidden{
            UIView.animate(withDuration: 0.5) {
                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
        let albumCover = ann.dropSong?.song.albumCover
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
        
        if !annotation.isKind(of: MKUserLocation.self){
            annotationView.image = albumCover
            annotationView.bounds.size.height /= 3.0
            annotationView.bounds.size.width /= 3.0
        }
        
        return annotationView
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
