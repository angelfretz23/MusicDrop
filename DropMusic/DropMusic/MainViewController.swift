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
    @IBOutlet weak var lockImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    var isLocked = true
    let cellID = "dropSongCell"
        
    var songAnnotations: [SongAnnotation]{
        return mapView.annotations.filter{ ($0 is MKUserLocation) == false} as! [SongAnnotation]
    }
    
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
        mapView.delegate = self
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
        toggleMapViewProperties(bool: !isLocked)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
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
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(DropSongCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:[v0(100)]-15-|", views: collectionView)
    }
    
    private func toggleMapViewProperties(bool: Bool){
        mapView.isZoomEnabled = bool
        mapView.isPitchEnabled = bool
        mapView.isRotateEnabled = bool
        mapView.isScrollEnabled = bool
    }
    
    @objc private func createAnnotation(){
        for songAnnotation in DropSongController.shared.songAnnotations {
            self.mapView.addAnnotation(songAnnotation)
            self.collectionView.reloadData()
            
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
    
    private func selectCurrentCollectionViewItamOnMapView(){
        let count = mapView.annotations.filter{ ($0 is MKUserLocation) == false}.count
        if count > 0 {
            let x = collectionView.contentOffset.x
            if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: x, y: 10)), let item = collectionView.cellForItem(at: indexPath) as? DropSongCollectionViewCell, let songAnnotation = item.songAnnotation {
                mapView.selectAnnotation(songAnnotation, animated: false)
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
                view.bounds.size = CGSize(width: 30, height: 30)
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
                annotationView.layer.shadowOpacity = 0.7
                annotationView.layer.shadowRadius = 5.0
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
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        if isLocked {
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 10, pitch: 45, heading: locationManager.heading?.trueHeading ?? 0)
            mapView.setCamera(camera, animated: true)
        }
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

extension MainViewController: InfoViewControllerDelegate {
    func infoViewDidDisappear() {
        if let currentSelectedAnnotation = mapView.selectedAnnotations.first{
            mapView.deselectAnnotation(currentSelectedAnnotation, animated: true)
        }
    }
}


// MARK: - Collection View Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DropSongCollectionViewCell
        cell.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        let songAnnotation = songAnnotations[indexPath.row]
        cell.songAnnotation = songAnnotation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapView.annotations.filter{ ($0 is MKUserLocation) == false}.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 30
        let height = collectionView.frame.height - 20
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DropSongCollectionViewCell
        guard let dropSong = cell.songAnnotation?.dropSong else { return }
        descriptionViewController.showDetailsWith(dropSong: dropSong)
    }
}

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x + 15 // adding inset
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: x, y: 10)), let cell = collectionView.cellForItem(at: indexPath) as? DropSongCollectionViewCell else { return }
        if let selectedAnnotation = cell.songAnnotation {
            self.mapView.selectAnnotation(selectedAnnotation, animated: true)
        }
    }
}
