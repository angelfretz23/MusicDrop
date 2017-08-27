//
//  InfoViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 7/31/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

protocol InfoViewControllerDelegate: class {
    func infoViewDidDisappear()
}

class InfoViewController: NSObject{
    
    let blackView = UIView()
    
    weak var delegate: InfoViewControllerDelegate?
    
    let infoView: InfoView = {
        let iv = InfoView()
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    func showDetailsWith(dropSong: DropSong){
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissWith(sender:)))
            infoView.addGestureRecognizer(panGestureRecognizer)
            
            window.addSubview(blackView)
            window.addSubview(infoView)
            blackView.alpha = 1
            blackView.frame = window.frame
            infoView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height/3)
            update(with: dropSong)
            showInfoView()
        }
    }
    
    private func showInfoView(){
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                let y =  window.frame.height - (window.frame.height / 3)
                self.infoView.frame.origin = CGPoint(x: 0, y: y)
            }, completion: nil)
        }
    }
    
    final func dismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.infoView.frame.origin = CGPoint(x: 0, y: window.frame.height)
                self.delegate?.infoViewDidDisappear()
            }
        }) { (completed) in
            
        }
    }
    
    final func dismissWith(sender: UIPanGestureRecognizer){
        guard let superView = infoView.superview else { return }
        
        let translation = sender.translation(in: superView)
        let percentThreshold:CGFloat = 0.75
        let progress = infoView.frame.origin.y / superView.frame.size.height
        let threshold = superView.frame.height - (superView.frame.height / 3)
        switch sender.state{
        case .changed:
            if infoView.frame.origin.y + translation.y > threshold {
                infoView.frame.origin = CGPoint(x: 0, y: infoView.frame.origin.y + translation.y)
            }
        case .ended:
            progress > percentThreshold ? dismiss() : showInfoView()
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: superView)
    }
    
    final func update(with dropSong: DropSong){
        infoView.songTitleLabel.text = dropSong.song.songName
        infoView.artistTitleLabel.text = dropSong.song.artistName
        infoView.droppedByTitleLabel.text = dropSong.postedBy ?? ""
        infoView.descriptionTextView.text = dropSong.description ?? ""
        ImageController.fetchImage(withString: dropSong.song.imageURL!) { (image) in
            self.infoView.albumImageView.image = image
        }
    }
}
