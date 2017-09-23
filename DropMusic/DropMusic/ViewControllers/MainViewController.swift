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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stackView: UIStackView!
    
    var locationManager = CLLocationManager()
    var isLocked = false
    let cellID = "dropSongCell"
        
    var songAnnotations: [SongAnnotation]{
        return mapView.annotations.filter{ ($0 is MKUserLocation) == false} as! [SongAnnotation]
    }
    
    lazy var musicPlayerView: MusicPlayerView = {
        let mPV = MusicPlayerView(frame: .zero)
        mPV.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        mPV.autoresizesSubviews = true
        return mPV
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var descriptionViewController = DescriptionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUpMusicPlayer()
        
        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped(sender:))))
        locationManager.delegate = self
        setupCollectionView()
        let notificationName = Notification.Name(rawValue: "newDropSongAdded")
        let deselectAnnotations = Notification.Name(rawValue: "delectAllAnnotations")
        
        NotificationCenter.default.addObserver(self, selector: #selector(createAnnotation), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(delectAllAnnotations), name: deselectAnnotations, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQuickLocationUpdate()
        CLLocationManager.headingAvailable() ? locationManager.startUpdatingHeading() : ()
//        toggleMapViewProperties(bool: !isLocked)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.register(DropSongCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:[v0(136)]-18-|", views: collectionView)
    }
    
    @objc private func createAnnotation(){
        collectionView.isHidden = (DropSongController.shared.songAnnotations.count == 0)
        for songAnnotation in DropSongController.shared.songAnnotations {
            self.mapView.addAnnotation(songAnnotation)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func delectAllAnnotations(){
        if mapView.selectedAnnotations.count > 0 {
            mapView.selectedAnnotations.forEach({ (ann) in
                mapView.deselectAnnotation(ann, animated: false)
            })
            
            DispatchQueue.main.async {
                self.selectCurrentCollectionViewItamOnMapView()
            }
        }
    }
    
    @objc private func mapViewTapped(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            let tappedCoordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let CLLocationFromCoordinates = CLLocation(latitude: tappedCoordinates.latitude, longitude: tappedCoordinates.longitude)
            let annotaions = self.mapView.annotations
            self.mapView.removeAnnotations(annotaions)
            _ = CloudKitManager()
            centerMapOnLocation(location: CLLocationCoordinate2D(latitude: tappedCoordinates.latitude, longitude: tappedCoordinates.longitude))
            DropSongController.shared.fetchDropSongsWith(location: CLLocationFromCoordinates, radiusInMeters: 1) { (songAnnotation) in
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(songAnnotation)
                    self.collectionView.isHidden = (self.mapView.annotations.count == 0)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func selectCurrentCollectionViewItamOnMapView(){
        let count = mapView.annotations.filter{ ($0 is MKUserLocation) == false}.count
        if count > 0 {
            let x = collectionView.contentOffset.x
            if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: x, y: 10)), let item = collectionView.cellForItem(at: indexPath) as? DropSongCollectionViewCell, let songAnnotation = item.songAnnotation {
                mapView.selectAnnotation(songAnnotation, animated: false)
            }
        }
    }
    
    private func setupUpMusicPlayer() {
        stackView.insertArrangedSubview(musicPlayerView, at: 0)
        stackView.addConstraintsWithFormat(format: "H:|[v0]|", views: musicPlayerView)
        stackView.addConstraintsWithFormat(format: "V:|[v0(40)]|", views: musicPlayerView)
    }
    
    
    var musicPlayerViewToggle: Bool = true
    
    @objc private func toggleMusicPlayerView(){
        UIView.animate(withDuration: 0.5) {
            if let window = UIApplication.shared.keyWindow {
//                self.musicPlayerViewToggle ? (self.musicPlayerView.frame.size = CGSize(width: window.bounds.width, height: 0)) : (self.musicPlayerView.frame.size = CGSize(width: window.bounds.width, height: 50))
                self.musicPlayerViewToggle ? (self.musicPlayerView.frame.origin = CGPoint.zero) : (self.musicPlayerView.frame.origin = self.view.frame.origin)
//                self.musicPlayerViewToggle ? (self.musicPlayerView.alpha = 0) : (self.musicPlayerView.alpha = 1)
                self.musicPlayerViewToggle = !self.musicPlayerViewToggle
            }
        }
    }
    
}

extension MainViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is SongAnnotation{
            UIView.animate(withDuration: 0.1) {
                view.frame.size = CGSize(width: 50, height: 50)
                view.superview?.bringSubview(toFront: view)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is SongAnnotation{
            UIView.animate(withDuration: 0.1) {
                view.frame.size = CGSize(width: 30, height: 30)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SongAnnotation{
            guard let ann = annotation as? SongAnnotation else { return MKAnnotationView() }
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "dropSong") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "dropSong")
            
            if !annotation.isKind(of: MKUserLocation.self){
                ImageController.fetchImage(withString: (ann.dropSong?.song.imageURL)!, with: 30, completion: { (image) in
                    annotationView.image = image
                })
                annotationView.bounds.size = CGSize(width: 30, height: 30)
                annotationView.layer.shadowColor = UIColor.gray.cgColor
                annotationView.layer.shadowOpacity = 0.3
                annotationView.layer.shadowRadius = 5.0
                annotationView.layer.cornerRadius = annotationView.frame.height / 2
                annotationView.clipsToBounds = true
                annotationView.layer.shadowOffset = CGSize(width: 5, height: 5)
                annotationView.canShowCallout = false
                annotationView.isEnabled = false
            }
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
            
            if annotationView.annotation is MKUserLocation{
                annotationView.canShowCallout = false
                annotationView.isEnabled = false
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 1000, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
        
        DropSongController.shared.songAnnotations.removeAll()
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        collectionView.reloadData()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        collectionView.reloadData()
    }
}

extension MainViewController: CLLocationManagerDelegate{
    func getQuickLocationUpdate(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
}


