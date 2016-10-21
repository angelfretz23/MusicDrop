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
        centerMapOnLocation(location: location.coordinate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticatePermissionToUseCurrentPostion()
        createMOCAnnotations()
    }
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let songID = self.songID else { return }
        
        if !(musicPlayer.playbackState == MPMusicPlaybackState.playing){
            musicPlayer.setQueueWithStoreIDs([songID])
            playButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            musicPlayer.play()
        } else {
            musicPlayer.pause()
            playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            if !annotationDetailView.isHidden{
                UIView.animate(withDuration: 0.3) {
                    self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                    !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
                }
            }
        }
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
            centerMapOnLocation(location: location.coordinate)
            updated = true
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print(mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        musicPlayer.pause()
        playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        
        if annotationDetailView.isHidden && !(view.annotation?.isKind(of: MKUserLocation.self))!{
            UIView.animate(withDuration: 0.3) {
                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
            }
        }
        guard let annotation = view.annotation as? SongAnnotation else { return }
        
        centerMapOnLocation(location: annotation.coordinate)
        albumCover.image = annotation.dropSong?.song.albumCover
        songNameLabel.text = annotation.dropSong?.song.songName
        artistNameLabel.text = annotation.dropSong?.song.artistSong
        albumNameLabel.text = annotation.dropSong?.song.albumName
        droppedByLabel.text = annotation.dropSong?.postedBy
        discriptionTextView.text = annotation.dropSong?.description
        songID = annotation.dropSong?.song.storeID
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        if !annotationDetailView.isHidden{
//            UIView.animate(withDuration: 0.3) {
//                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
//                !(self.annotationDetailView.isHidden) ? (self.annotationDetailView.alpha = 1.0) : (self.annotationDetailView.alpha = 0.0)
//            }
//        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
        let albumCover = ann.dropSong?.song.albumCover
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
        
        if !annotation.isKind(of: MKUserLocation.self){
            annotationView.image = ImageController.getNewAnnotation(albumCover: albumCover?.circle)
            annotationView.bounds.size.height /= 2
            annotationView.bounds.size.width /= 2
            annotationView.layer.shadowColor = UIColor.gray.cgColor
            annotationView.layer.shadowOpacity = 0.7
            annotationView.layer.shadowRadius = 5.0
            annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
        } else {
            return MKAnnotationView(annotation: ann, reuseIdentifier: "dropSong")
        }
        
        return annotationView
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        let regionRadius: CLLocationDistance = 200
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
//        mapView.camera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 15, pitch: 90, heading: 0)

        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotationFrom(dropSong: DropSong){
        let songAnnotation = SongAnnotation(dropSong: dropSong)
        mapView.addAnnotation(songAnnotation)
    }
    
}
