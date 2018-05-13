//
//  MainViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/17/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import MapKit

protocol MainViewControllerDelegate: class {
    func didSelectClusterAnnotation(with songAnnotations: [SongAnnotation])
    func didDeselectClusterAnnotation()
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var controlPanel: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchThisAreaButton: UIButton!
    @IBOutlet weak var bottonLayoutConstraint: NSLayoutConstraint!
    
    fileprivate let bottomConstraintDistance: CGFloat = 8.0
    
    var locationManager = CLLocationManager()
    
    weak var delegate: MainViewControllerDelegate?
        
    var songAnnotations: [SongAnnotation]{
        return mapView.annotations.filter{ ($0 is MKUserLocation) == false} as! [SongAnnotation]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.projectBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        controlPanel.layer.cornerRadius = 5
        searchThisAreaButton.layer.cornerRadius = 7

        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped(sender:))))
        locationManager.delegate = self               

        let deselectAnnotations = Notification.Name(rawValue: "delectAllAnnotations")

        NotificationCenter.default.addObserver(self, selector: #selector(delectAllAnnotations), name: deselectAnnotations, object: nil)
        setupControlPanel()
        
        mapView.register(SongView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        setupLocationButton()
        
        searchThisAreaButton.tintColor = .projectBlue
        searchThisAreaButton.backgroundColor = .projectBlack
        
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location.coordinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        CLLocationManager.headingAvailable() ? locationManager.startUpdatingHeading() : ()
        
        addCacheAnnotations()
    }

    private func addCacheAnnotations() {
        if DropSongController.shared.tempSongAnnotations.count > 0 {
            DropSongController.shared.tempSongAnnotations.forEach { (songAnnotation) in
                self.mapView.addAnnotation(songAnnotation)
            }
            DropSongController.shared.tempSongAnnotations.removeAll()
        }
    }
    
    private func setupControlPanel() {
        controlPanel.backgroundColor = .projectBlack
        
        addButton.tintColor = .projectBlue
    }
    
    private func setupLocationButton() {
        let button = MKUserTrackingButton(mapView: mapView)
        button.tintColor = .projectBlue
        controlPanel.addSubview(button)
        
        controlPanel.addConstraintsWithFormat(format: "V:[v0]-8-[v1]", views: addButton, button)
        button.centerXAnchor.constraint(equalTo: controlPanel.centerXAnchor).isActive = true
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let searchNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchNavigationController")
        self.pulleyViewController?.present(searchNavigationController, animated: true, completion: nil)
        
    }
    
    @objc private func createAnnotation(){
        self.mapView.addAnnotations(DropSongController.shared.songAnnotations)
    }
    
    @objc private func delectAllAnnotations(){
        if mapView.selectedAnnotations.count > 0 {
            mapView.selectedAnnotations.forEach({ (ann) in
                mapView.deselectAnnotation(ann, animated: false)
            })
        }
    }
    
    @objc private func mapViewTapped(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            let tappedCoordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let CLLocationFromCoordinates = CLLocation(latitude: tappedCoordinates.latitude, longitude: tappedCoordinates.longitude)
            let annotaions = self.mapView.annotations
            self.mapView.removeAnnotations(annotaions)
            DropSongController.shared.fetchDropSongsWith(location: CLLocationFromCoordinates, radiusInMeters: 1) { (songAnnotation) in
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(songAnnotation)
                }
            }
        }
    }
    
    @IBAction func searchThisAreaPressed(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        DropSongController.shared.fetchDropSongsWith(location: centerLocation, radiusInMeters: mapView.currentRadius) { (songAnnotation) in
            DispatchQueue.main.async {
                self.mapView.addAnnotation(songAnnotation)
            }
        }
        fadeSearchButton()
    }
    
    func fadeSearchButton() {
        UIView.animate(withDuration: 0.4, animations: {
            self.searchThisAreaButton.alpha = 0
        }) { (_) in
            self.searchThisAreaButton.isHidden = true
        }
    }
    
    func showSearchButton() {
        self.searchThisAreaButton.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.searchThisAreaButton.alpha = 1.0
        }) { (_) in
            
        }
    }
}

extension MainViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is SongAnnotation{
            let songAnnotation = view.annotation as? SongAnnotation
            let storeID = songAnnotation?.dropSong?.song.storeID
            if let id = storeID {
                let mp = MusicPlayerController()
                mp.playSongWith(id: id)
                mp.play()
            }
        } else if view.annotation is MKClusterAnnotation {
            guard let clusterView = view.annotation as? MKClusterAnnotation, let songAnnotations = clusterView.memberAnnotations as? [SongAnnotation] else { return }
            delegate?.didSelectClusterAnnotation(with: songAnnotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKClusterAnnotation {
            delegate?.didDeselectClusterAnnotation()
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.showSearchButton()
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

extension MainViewController: PulleyPrimaryContentControllerDelegate {
    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        guard let drawer = self.pulleyViewController, drawer.currentDisplayMode == .bottomDrawer else {
            controlPanel.alpha = 1.0
            return
        }
        
        controlPanel.alpha = 1.0 - progress
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        guard drawer.currentDisplayMode == .bottomDrawer else {
            bottonLayoutConstraint.constant =  bottomConstraintDistance
            return
        }
        
        if distance <= 268 + bottomSafeArea {
            bottonLayoutConstraint.constant = distance + bottomConstraintDistance
        } else {
            bottonLayoutConstraint.constant = 268.0 + bottomConstraintDistance
        }
    }
}
