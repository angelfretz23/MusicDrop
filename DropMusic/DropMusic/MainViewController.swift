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

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var droppedByLabel: UILabel!
    @IBOutlet weak var albumArtworkImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoContainerView: UIView!

    
    var locationManager = CLLocationManager()
    var updated = false
    
    let gcdController = GCDController()
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var songID:String?
    var mapViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)
        let notificationName = Notification.Name(rawValue: "newDropSongAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(createMOCAnnotations), name: notificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQuickLocationUpdate()
    }
    
    @IBAction func songDescriptionCellPressed(_ sender: Any) {
        
    }
    
    func createMOCAnnotations(){
        for dropSong in DropSongController.sharedController.dropSongs {
            createAnnotationFrom(dropSong: dropSong)
        }
    }
}

extension MainViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? SongAnnotation,
            let dropSong = annotation.dropSong else { return }
        
        centerMapOnLocation(location: annotation.coordinate)
        
        ImageController.fetchImage(withString: (dropSong.song.imageURL)!) { (image) in
            self.albumArtworkImageView.image = image
        }
        songNameLabel.text = dropSong.song.songName
        artistNameLabel.text = dropSong.song.artistName
        droppedByLabel.text = dropSong.postedBy
        songID = dropSong.song.storeID
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.3) {
            view.bounds.size = CGSize(width: 30, height: 30)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "dropSong") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        gcdController.backgroundThread(background: {
            if !annotation.isKind(of: MKUserLocation.self){
                ImageController.fetchImage(withString: (ann.dropSong?.song.imageURL)!, with: 30, completion: { (image) in
                    annotationView.image = image
                })
                annotationView.bounds.size = CGSize(width: 30, height: 30)
                annotationView.layer.shadowColor = UIColor.gray.cgColor
                annotationView.layer.shadowOpacity = 0.7
                annotationView.layer.shadowRadius = 5.0
                annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
                annotationView.canShowCallout = false
            }
        })
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for annotationView in views{
            let endFrame = annotationView.frame
            annotationView.frame = endFrame.offsetBy(dx: 0, dy: -500)
            UIView.animate(withDuration: 0.5, animations: {
                annotationView.frame = endFrame
            })
        }
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        mapView.setCenter(location, animated: true)
    }
    
    func createAnnotationFrom(dropSong: DropSong){
        DispatchQueue.main.async {
            let songAnnotation = SongAnnotation(dropSong: dropSong)
            self.mapView.addAnnotation(songAnnotation)
        }
    }
}

extension MainViewController: CLLocationManagerDelegate{
    func getQuickLocationUpdate(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = self.locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)
        
        
        self.locationManager.stopUpdatingLocation()
    }
}
