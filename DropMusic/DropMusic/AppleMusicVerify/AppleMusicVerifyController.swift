//
//  AppleMusicVerifyViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/10/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import StoreKit

final class AppleMusicVerifyController {
    static let shared = AppleMusicVerifyController()
    
    init() {
        requestAppleMusicAuthorization()
    }
    
    private func requestAppleMusicAuthorization(){
        SKCloudServiceController.requestAuthorization { (authorizationStatus) in
            switch authorizationStatus {
            case .authorized:
                print("AUTHORIZED")
            case .denied:
                print("DENIED")
            case .notDetermined:
                print("NOT DETERMINED")
            case .restricted:
                print("RESTRICTED")
            }
        }
    }
    
    public func appleMusicCheckIfDeviceCanPlayback(completion: @escaping (Bool) -> ()){
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability, error) in
            if capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
                completion(true)
            } else if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                print("The user has an Apple Music subscription and can playback music!")
                completion(true)
            } else {
                print("The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
                completion(false)
            }
        }
    }
}

