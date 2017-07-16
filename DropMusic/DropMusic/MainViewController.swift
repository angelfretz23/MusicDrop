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
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    var isLocked = true
    var infoContainerViewDisplayed = true
    
    let gcdController = GCDController()
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var songID:String?
    var mapViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        hideInfoContainer()
        infoContainerView.layer.borderWidth = 2.0
        infoContainerView.layer.borderColor = UIColor.darkGray.cgColor
        infoContainerView.layer.cornerRadius = 10
        
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
        CLLocationManager.headingAvailable() ? locationManager.startUpdatingHeading() : ()
        toggleMapViewProperties(bool: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songDropDetail"{
            guard let songAnnotation = mapView.selectedAnnotations.first as? SongAnnotation else { return }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "songDropDetail"{
            if mapView.selectedAnnotations.count <= 0 {
                return false
            }
        }
        return true
    }
    func createMOCAnnotations(){
        for dropSong in DropSongController.sharedController.dropSongs {
            createAnnotationFrom(dropSong: dropSong)
        }
    }
    
    func showInfoContainer(){
        if !infoContainerViewDisplayed{
            infoContainerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.infoContainerView.center.y -= self.view.bounds.height / 2
                self.infoContainerViewDisplayed = true
            })
        }
    }
    
    func hideInfoContainer() {
        if infoContainerViewDisplayed{
            self.infoContainerView.center.y += self.view.bounds.height / 2
            self.infoContainerViewDisplayed = false
            infoContainerView.isHidden = true
        }
    }
    @IBAction private func lockImageViewPressed(_ sender: Any) {
        if lockImageView.tag == 0 {
            toggleMapViewProperties(bool: true)
            lockImageView.tag = 1
            lockImageView.image = #imageLiteral(resourceName: "unlock")
            self.locationManager.stopUpdatingLocation()
            isLocked = false
        } else if lockImageView.tag == 1{
            toggleMapViewProperties(bool: false)
            lockImageView.tag = 0
            lockImageView.image = #imageLiteral(resourceName: "lock")
            self.locationManager.startUpdatingLocation()
            isLocked = true
        }
        
    }
    
    private func toggleMapViewProperties(bool: Bool){
        mapView.isZoomEnabled = bool
        mapView.isPitchEnabled = bool
        mapView.isRotateEnabled = bool
        mapView.isScrollEnabled = bool
    }
}

extension MainViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is SongAnnotation{
            UIView.animate(withDuration: 0.1) {
                view.bounds.size = CGSize(width: 50, height: 50)
            }
            
            guard let annotation = view.annotation as? SongAnnotation,
                let dropSong = annotation.dropSong else { return }
            
            //        centerMapOnLocation(location: annotation.coordinate)
            showInfoContainer()
            ImageController.fetchImage(withString: (dropSong.song.imageURL)!) { (image) in
                self.albumArtworkImageView.image = image
            }
            songNameLabel.text = dropSong.song.songName
            artistNameLabel.text = dropSong.song.artistName
            droppedByLabel.text = "Dropped by \(dropSong.postedBy ?? "")"
            songID = dropSong.song.storeID
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is SongAnnotation{
            UIView.animate(withDuration: 0.1) {
                view.bounds.size = CGSize(width: 30, height: 30)
                if mapView.selectedAnnotations.count == 0 {
                    self.hideInfoContainer()
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SongAnnotation{
            guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "dropSong") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
            
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
        return nil
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
        if isLocked {
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 10, pitch: 45, heading: locationManager.heading?.trueHeading ?? 0)
            mapView.setCamera(camera, animated: true)
        }
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
        if isLocked {
            guard let location = self.locationManager.location else { return }
            centerMapOnLocation(location: location.coordinate)
            manager.distanceFilter = 10
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if isLocked{
            mapView.camera.heading = newHeading.trueHeading
        }
    }
}
