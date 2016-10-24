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
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let song = song{
            updateWith(song: song)
        }
        loadMapView()
        addAnnotationOnLoad()
        descriptionTextView.delegate = self
        mapView.delegate = self
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
        print()
        mediaPlayer.play()
    }
    
    func updateWith(song: Song){
        albumCover.image = song.albumCover
        songNameLabel.text = song.songName
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
    }
    
    func addAnnotationOnLoad(){
        guard let location = locationManager.location else { return }
        mapView.addAnnotation(SongAnnotation(coordinate: location.coordinate))
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
//        guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
        guard let song = song else { print("Song is nil"); return MKAnnotationView() }
        guard let albumCover = song.albumCover else { print("AlbumCover was nil"); return MKAnnotationView() }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
        
        if !annotation.isKind(of: MKUserLocation.self){
            annotationView.image = ImageController.getNewAnnotation(albumCover: albumCover.circle)
            annotationView.bounds.size.height /= 2
            annotationView.bounds.size.width /= 2
            annotationView.layer.shadowColor = UIColor.gray.cgColor
            annotationView.layer.shadowOpacity = 0.7
            annotationView.layer.shadowRadius = 5.0
            annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
        } else {
            return MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
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

