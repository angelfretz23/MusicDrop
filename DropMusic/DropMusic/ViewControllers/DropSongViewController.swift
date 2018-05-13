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
    // MARK: - SubViews
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.isZoomEnabled = false
        mv.isRotateEnabled = false
        mv.isScrollEnabled = false
        mv.showsTraffic = false
        mv.showsScale = false
        mv.showsUserLocation = false
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let writeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Write a Description"
        return label
    }()
    
    let albumCover: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    let blackView = UIView()

    var song: Song?
    
    var collectionImage: UIImage?
    
    let mediaPlayer = MPMusicPlayerController.systemMusicPlayer
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        loadMapView()
        mapView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        mapView.register(SongView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.showsUserLocation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let song = song{
            updateWith(song: song)
        }
        getQuickLocationUpdate()
        addAnnotationOnLoad()
    }
    
    private func setupSubViews() {
        [mapView, songNameLabel, artistNameLabel, albumNameLabel, writeDescriptionLabel, descriptionTextView, albumCover].forEach { (subview) in
            self.view.addSubview(subview)
        }
        
        // Mapview Constraints
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mapView)
        view.addConstraintsWithFormat(format: "V:|[v0(300)]", views: mapView)
        
        // Album Cover
        view.addConstraintsWithFormat(format: "H:[v0(75)]-|", views: albumCover)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1(75)]", views: mapView, albumCover)
        
        // Labels
        view.addConstraintsWithFormat(format: "H:|-[v0]-[v1]", views: songNameLabel, albumCover)
        view.addConstraintsWithFormat(format: "H:|-[v0]-[v1]", views: artistNameLabel, albumCover)
        view.addConstraintsWithFormat(format: "H:|-[v0]-[v1]", views: albumNameLabel, albumCover)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1(20)][v2(20)][v3(20)]", views: mapView, songNameLabel, artistNameLabel, albumNameLabel)
        
        // Description Label and Text View
        view.addConstraintsWithFormat(format: "H:|-[v0]", views: writeDescriptionLabel)
        view.addConstraintsWithFormat(format: "H:|-[v0]-|", views: descriptionTextView)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1(25)][v2(100)]", views: albumCover, writeDescriptionLabel, descriptionTextView)
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let location = locationManager.location else { return }
        let dropSong = DropSong(postCoordinates: location, song: self.song!, postedBy: UsernameController.shared.getUserName(), description: descriptionTextView.text)
        DropSongController.shared.post(dropSong: dropSong, addToCache: true)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        guard let storeID = song?.storeID else { return }
        playSongWith(id: storeID)
    }
    
    func playSongWith(id: String...){
        mediaPlayer.setQueue(with: id)
        
        mediaPlayer.play()
    }
    
    func updateWith(song: Song){
        ImageController.fetchImage(withString: (song.imageURL)!, with: 50, id: song.storeID) { (image) in
            self.albumCover.image = image
            self.collectionImage = image
        }
        songNameLabel.text = song.songName
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
    }
    
    func addAnnotationOnLoad(){
        guard let location = locationManager.location, let song = song else { return }
        let dropSong = DropSong(postCoordinates: location, song: song, description: nil)
        let songAnnotation = SongAnnotation.songAnnotation(fromDropSong: dropSong)
        mapView.addAnnotation(songAnnotation)
    }
    
    @objc private func keyboardDidShow(notification: Notification){
        view.bringSubview(toFront: descriptionTextView)
        
        let size = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? CGRect)?.size
        let keyboardHeight = size?.height ?? 258
        print(descriptionTextView.frame)
        
        let padding: CGFloat = 15
        let descriptionViewBottomY = descriptionTextView.frame.maxY
        let displacementValue: CGFloat = descriptionViewBottomY - (view.frame.height - keyboardHeight) + padding

        if let window = UIApplication.shared.keyWindow{
            view.insertSubview(blackView, belowSubview: descriptionTextView)
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
            blackView.alpha = 0.0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1.0
                self.view.frame.origin = CGPoint(x: 0, y: -151)
            }, completion: { (completed) in
                
            })
        }
    }
    
    @objc private func dismissKeyboard(){
//        blackView.removeFromSuperview()
        self.descriptionTextView.resignFirstResponder()
        let x = view.frame.origin.x
        let width = view.frame.width
        let height = view.frame.height
        
        UIView.animate(withDuration: 0.9, delay: 0.5, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.view.frame = CGRect(x: x, y: 0, width: width, height: height)
        }, completion: { (completed) in
            
        })
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
}

extension DropSongViewController: CLLocationManagerDelegate{
    func getQuickLocationUpdate(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = false
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

