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
        guard let url = URL(string: url) else {completion(nil); return }
        guard let data = (try? Data(contentsOf: url)) else {completion(nil); return }
        
        DispatchQueue.main.async {
            completion(UIImage(data: data))
        }
    }
}
