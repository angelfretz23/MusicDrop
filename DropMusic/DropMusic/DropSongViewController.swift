//
//  DropSongViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/16/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import MapKit
import StoreKit
import MediaPlayer

class DropSongViewController: UIViewController {
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var song: Song?
    let gcdController = GCDController()
    
    var collectionImage: UIImage?
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the imageURL is: \(song?.imageURL)")
        loadMapView()
        descriptionTextView.delegate = self
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let song = song{
            updateWith(song: song)
        }
        getQuickLocationUpdate()
        addAnnotationOnLoad()
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let location = locationManager.location else { return }
        let dropsong = DropSong(postCoordinates: location, song: self.song!, description: descriptionTextView.text)
        DropSongController.sharedController.post(dropSong: dropsong)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        guard let storeID = song?.storeID else { return }
        playSongWith(id: storeID)
    }
    
    func playSongWith(id: String...){
        mediaPlayer.setQueueWithStoreIDs(id)
        
        mediaPlayer.play()
    }
    
    func updateWith(song: Song){
        ImageController.fetchImage(withString: (song.imageURL)!, with: 50) { (image) in
            self.albumCover.image = image
            self.collectionImage = image
        }
        songNameLabel.text = song.songName
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
    }
    
    func addAnnotationOnLoad(){
        guard let location = locationManager.location else { return }
        let songAnnotation = SongAnnotation(coordinate: location.coordinate)
        mapView.addAnnotation(songAnnotation)
    }
}

extension DropSongViewController: MKMapViewDelegate{
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        loadMapView()
    }
    func loadMapView() {
        let regionRadius: CLLocationDistance = 200
        guard let location = locationManager.location else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "newDropSong") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "newDropSong")
        if !annotation.isKind(of: MKUserLocation.self){
            annotationView.image = collectionImage
            annotationView.bounds.size.height = 50
            annotationView.bounds.size.width = 50
            annotationView.layer.shadowColor = UIColor.gray.cgColor
            annotationView.layer.shadowOpacity = 0.7
            annotationView.layer.shadowRadius = 5.0
            annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
        } else {
            return nil
        }
        return annotationView
    }
}

extension DropSongViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Write a Description..."{
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }
}

extension DropSongViewController: CLLocationManagerDelegate{
    func getQuickLocationUpdate(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        loadMapView()
        self.locationManager.stopUpdatingLocation()
    }
}

