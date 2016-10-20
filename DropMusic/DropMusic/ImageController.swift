//
//  ImageController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

class ImageController{
    
    static func fetchImage(withString url: String, completion: @escaping (_ image: UIImage?) -> Void){
        guard let url = URL(string: url) else {completion(nil); return }
        guard let data = (try? Data(contentsOf: url)) else {completion(nil); return }
        
        DispatchQueue.main.async {
            completion(UIImage(data: data))
        }
    }
    
//    private static func resize(image: UIImage?, scaleToSize newSize: CGSize) -> UIImage?{
//        guard let image = image else { return nil }
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        
//        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
//    
    static func getNewAnnotation(albumCover: UIImage?,with annotation: UIImage? = #imageLiteral(resourceName: "Annotation1x")) -> UIImage?{
        guard let albumCover = albumCover else { print("album cover was nil"); return nil}
        guard let annotation = annotation else { print("annotation was nil"); return nil}
        
        let size = annotation.size
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        annotation.draw(in: areaSize)
        
        let albumCoverSize = CGRect(x: 11, y: 11, width: 79, height: 79)
        albumCover.draw(in: albumCoverSize)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage
    }
}
