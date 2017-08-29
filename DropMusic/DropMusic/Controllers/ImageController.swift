//
//  ImageController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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
    
    static private let cache = NSCache<NSString, UIImage>()
    
    static func fetchImage(withString url: String, with size: Double = 500, completion: @escaping (UIImage?) -> Void){
        if var imageFromCache = cache.object(forKey: NSString(string: url)) {
            if size != 500 {
                imageFromCache = imageWith(image: imageFromCache, scaleToSize: CGSize(width: size, height: size))!
            }
            DispatchQueue.main.async {
                completion(imageFromCache)
            }
        } else {
            let urlNSString = NSString(string: url)
            guard let url = URL(string: url) else { return }
            
            NetworkController.performRequest(for: url, httpMethodString: "GET") { (data, error) in
                guard let data = data else {completion(nil); return }
                if let image = UIImage(data: data){
                    let resizedImage = imageWith(image: UIImage(data: data), scaleToSize: CGSize(width: size, height: size))
                    self.cache.setObject(image, forKey: urlNSString)
                    DispatchQueue.main.async {
                        completion(resizedImage)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }

    static func getNewAnnotation(albumCover: UIImage?,with annotation: UIImage? = #imageLiteral(resourceName: "Annotation1x"), completion: @escaping (_ annotationImage: UIImage?)->Void) {
            guard let albumCover = albumCover else {completion(nil); print("album cover was nil"); return}
            guard let annotation = annotation else { completion(nil); print("annotation was nil"); return}
            
            let size = annotation.size
            UIGraphicsBeginImageContext(size)
            
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            annotation.draw(in: areaSize)
            
            let albumCoverSize = CGRect(x: 11, y: 11, width: 79, height: 79)
            albumCover.draw(in: albumCoverSize)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            let resizedImage = imageWith(image: newImage, scaleToSize: CGSize(width: 100, height: 100))
            
            DispatchQueue.main.async {
                completion(resizedImage)
            }
    }
    
    static func imageWith(image: UIImage?, scaleToSize newSize: CGSize) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
