//
//  DescriptionViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/25/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

final class DescriptionViewController: NSObject {
    
    let blackView = UIView()
    
    let descriptionView: DescriptionView = {
        let descriptionView = DescriptionView(frame: CGRect.zero)
        descriptionView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        descriptionView.isUserInteractionEnabled = true
        return descriptionView
    }()
    
    private func showdescriptionView() {
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.descriptionView.center = window.center
            }, completion: nil)
        }
    }
    
    func showDetailsWith(dropSong: DropSong) {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissWith(sender:)))
            descriptionView.addGestureRecognizer(panGestureRecognizer)
            
            window.addSubview(blackView)
            window.addSubview(descriptionView)
            blackView.alpha = 1
            blackView.frame = window.frame
            if dropSong.description == "" {
                descriptionView.descriptionTextView.isHidden = true
                descriptionView.frame = CGRect(x: 40, y: window.frame.height, width: window.frame.width - 80, height: window.frame.height - 330)
            } else {
                descriptionView.descriptionTextView.isHidden = false
                descriptionView.frame = CGRect(x: 40, y: window.frame.height, width: window.frame.width - 80, height: window.frame.height - 140)
            }
            descriptionView.update(with: dropSong)
            descriptionView.sizeToFit()
            showdescriptionView()
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.descriptionView.frame.origin = CGPoint(x: 40, y: window.frame.height + 5)
            }
        }) { (completed) in
            
        }
    }
    
    @objc func dismissWith(sender: UIPanGestureRecognizer){
        guard let superView = descriptionView.superview else { return }
        
        let translation = sender.translation(in: superView)
        let percentThreshold:CGFloat = 0.15
        let progress = descriptionView.frame.origin.y / superView.frame.size.height
        let threshold = superView.frame.height - (superView.frame.height - 70)
        switch sender.state{
        case .changed:
            if descriptionView.frame.origin.y + translation.y > threshold {
                descriptionView.frame.origin = CGPoint(x: 40, y: descriptionView.frame.origin.y + translation.y)
            }
        case .ended:
            progress > percentThreshold ? dismiss() : showdescriptionView()
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: superView)
    }
}
