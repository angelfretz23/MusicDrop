//
//  GCDController.swift
//  DropMusic
//
//  Created by Angel Contreras on 11/13/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation

class GCDController{
    func backgroundThread(background: (() -> Void)? = nil, completion: (() -> Void)? = nil){
        DispatchQueue.global(qos: .background).async {
            if background != nil { background!() }
            
            DispatchQueue.main.async {
                if (completion != nil){ completion!(); }
            }
        } 
    }
}
