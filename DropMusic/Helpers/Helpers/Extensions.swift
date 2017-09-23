//
//  Extensions.swift
//  DropMusic
//
//  Created by Angel Contreras on 7/31/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

extension UIView{
    func addConstraintsWithFormat(format: String, options: NSLayoutFormatOptions = [], views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: viewsDictionary))
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIColor{
    var projectBlue: UIColor{
        return UIColor(red: 67/255, green: 191/255, blue: 254/255, alpha: 0.90)
    }
}
