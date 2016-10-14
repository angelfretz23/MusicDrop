//
//  iTunesSearchController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/14/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation

class ItunesSearchControllers{
    static let baseURL = URL(string: "https://itunes.apple.com/search?")
    static var parameters = ["entity": "songs", "limit": "30"]
    
    static func fetchSongs(with term: String, completion: @escaping (_ songs: [Song]?)-> Void){
        guard let url = baseURL else { completion(nil); return }
        
        parameters["term"] = term
        
        NetworkController.performRequest(for: url, httpMethodString: "GET", urlParameters: parameters, body: nil) { (data, error) in
            guard let data = data,
                let responseDataString = String.init(data: data, encoding: String.Encoding.utf8) else { completion(nil); return }
            
            if error != nil {
                print(error?.localizedDescription)
            } else if responseDataString.contains("error") {
                print("Error: \(responseDataString)")
            }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let resultsDictinary = jsonDictionary["results"] as? [[String:Any]] else { completion(nil); return }
            
            let songs = resultsDictinary.flatMap{ Song(dictionaryItunesSearch: $0) }
            
            DispatchQueue.main.async {
                completion(songs)
            }
        }
    }
}
