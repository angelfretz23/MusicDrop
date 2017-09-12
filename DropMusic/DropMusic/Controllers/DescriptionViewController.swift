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
    
    var horizontalCenterConstraint: NSLayoutConstraint?
    var verticalCenterConstraint: NSLayoutConstraint?
    
    let descriptionView: DescriptionView = {
        let descriptionView = DescriptionView()
        descriptionView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        descriptionView.isUserInteractionEnabled = true
        return descriptionView
    }()
    
    private func showdescriptionView() {
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                let x = (window.frame.maxX - self.descriptionView.frame.maxX) / 2
                let y = (window.frame.maxY - self.descriptionView.frame.maxY) / 2
                self.descriptionView.frame.origin = CGPoint(x: x, y: y)
            }) { (completed) in
//                self.descriptionView.circularProgress.animate(fromAngle: 0, toAngle: 360, duration: 50, completion: { (bool) in
//
//                })
            }
        }
    }
    
    func showDetailsWith(dropSong: DropSong) {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissWith(sender:)))
            descriptionView.addGestureRecognizer(panGestureRecognizer)
            
            window.addSubview(blackView)
            window.addSubview(descriptionView)
            blackView.alpha = 1
            blackView.frame = window.frame
            window.addConstraintsWithFormat(format: "H:[v0(<=350)]", views: descriptionView)
            window.addConstraintsWithFormat(format: "V:[v0(<=400)]", views: descriptionView)
            descriptionView.update(with: dropSong)
            showdescriptionView()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                let x = (window.frame.maxX - self.descriptionView.frame.maxX) / 2
                self.descriptionView.frame.origin = CGPoint(x: x, y: window.frame.height + 5)
            }
        }) { (completed) in
            
        }
    }
    
    func dismissWith(sender: UIPanGestureRecognizer){
        guard let superView = descriptionView.superview else { return }
        
        let translation = sender.translation(in: superView)
        let percentThreshold:CGFloat = 0.15
        let progress = descriptionView.frame.origin.y / superView.frame.size.height
        let threshold = superView.frame.height - (superView.frame.height - 70)
        switch sender.state{
        case .changed:
            if descriptionView.frame.origin.y + translation.y > threshold, let window = UIApplication.shared.keyWindow {
                let x = (window.frame.maxX - descriptionView.frame.maxX) / 2
                descriptionView.frame.origin = CGPoint(x: x, y: descriptionView.frame.origin.y + translation.y)
            }
        case .ended:
            progress > percentThreshold ? dismiss() : showdescriptionView()
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: superView)
    }
}
