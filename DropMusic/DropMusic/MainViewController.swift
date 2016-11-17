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
    var updated = false
    
    let gcdController = GCDController()
    
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var songID:String?
    var mapViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        annotationDetailView.isHidden = true
        mapView.delegate = self
        locationManager.delegate = self
        mapViewHeightConstraint = NSLayoutConstraint(item: self.mapView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.6, constant: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        super.viewDidAppear(animated)
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)
        let notificationName = Notification.Name(rawValue: "newDropSongAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(createMOCAnnotations), name: notificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
        getQuickLocationUpdate()
    }
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        print(#function)
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
        print(#function)
        for dropSong in DropSongController.sharedController.dropSongs {
            createAnnotationFrom(dropSong: dropSong)
        }
    }
}

extension MainViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(#function)
        musicPlayer.pause()
        playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        
        if annotationDetailView.isHidden && !(view.annotation?.isKind(of: MKUserLocation.self))!{
            print(#function)
            UIView.animate(withDuration: 0.3) {
                self.annotationDetailView.isHidden = !self.annotationDetailView.isHidden
                if !(self.annotationDetailView.isHidden) {
                    self.annotationDetailView.alpha = 1.0
                    guard let mapViewHeightConstraint = self.mapViewHeightConstraint else{ print("Constraint is empty"); return }
                    self.view.addConstraint(mapViewHeightConstraint)
                } else {
                    self.annotationDetailView.alpha = 0.0
                    self.view.removeConstraint(self.mapViewHeightConstraint!)
                }
            }
        }
        guard let annotation = view.annotation as? SongAnnotation else { return }
        
        centerMapOnLocation(location: annotation.coordinate)
        
        ImageController.fetchImage(withString: (annotation.dropSong?.song.imageURL)!) { (image) in
            self.albumCover.image = image
        }
        songNameLabel.text = annotation.dropSong?.song.songName
        artistNameLabel.text = annotation.dropSong?.song.artistName
        albumNameLabel.text = annotation.dropSong?.song.albumName
        droppedByLabel.text = annotation.dropSong?.postedBy
        discriptionTextView.text = annotation.dropSong?.description
        songID = annotation.dropSong?.song.storeID
        
        view.bounds.size = CGSize(width: 50, height: 50)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.bounds.size = CGSize(width: 30, height: 30)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(#function)
        guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "dropSong") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
        
        gcdController.backgroundThread(background: {
            if !annotation.isKind(of: MKUserLocation.self){
                ImageController.fetchImage(withString: (ann.dropSong?.song.imageURL)!, with: 30, completion: { (image) in
                    annotationView.image = image
                })
                annotationView.bounds.size.height /= 1.5
                annotationView.bounds.size.width /= 1.5
                annotationView.layer.shadowColor = UIColor.gray.cgColor
                annotationView.layer.shadowOpacity = 0.7
                annotationView.layer.shadowRadius = 5.0
                annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
                annotationView.canShowCallout = false
            }
        })
        if annotation.isKind(of: MKUserLocation.self) {
            return MKAnnotationView()
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        print(#function)
        for annotationView in views{
            let endFrame = annotationView.frame
            annotationView.frame = endFrame.offsetBy(dx: 0, dy: -500)
            UIView.animate(withDuration: 0.5, animations: {
                annotationView.frame = endFrame
            })
        }
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        print(#function)
        let regionRadius: CLLocationDistance = 200
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        //        mapView.camera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 15, pitch: 90, heading: 0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotationFrom(dropSong: DropSong){
        print(#function)
        DispatchQueue.main.async {
            let songAnnotation = SongAnnotation(dropSong: dropSong)
            self.mapView.addAnnotation(songAnnotation)
        }
    }
}

extension MainViewController: CLLocationManagerDelegate{
    func getQuickLocationUpdate(){
        print(#function)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        guard let location = self.locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)

        
        self.locationManager.stopUpdatingLocation()
    }
}
