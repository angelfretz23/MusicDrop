//
//  ImageController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation
import UIKit

class ImageController{
    
    static func fetchImage(withString url: String, completion: @escaping (_ image: UIImage?) -> Void){
        guard let url = URL(string: url) else { return }
        NetworkController.performRequest(for: url, httpMethodString: "GET") { (data, error) in
            guard let data = data else { completion(nil); print("There was nothing"); return }
            print(data)
            guard let responseDataString = String.init(data: data, encoding: String.Encoding.utf8) else { completion(nil); return }
            
            if error != nil{
                print(error?.localizedDescription)
            } else if responseDataString.contains("error") {
                print("Error: \(responseDataString)")
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
}
