//
//  MainViewController+CollectionView.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/12/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Collection View Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DropSongCollectionViewCell
        cell.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
//        cell.layer.masksToBounds = false
        let songAnnotation = songAnnotations[indexPath.row]
        cell.songAnnotation = songAnnotation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapView.annotations.filter{ ($0 is MKUserLocation) == false}.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DropSongCollectionViewCell
        cell?.play()
        musicPlayerView.albumCoverView.image = cell?.albumCoverImage.image
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 30
        let height: CGFloat = 136
        return CGSize(width: width, height: height)
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
