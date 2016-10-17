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
    static var parameters = ["entity": "song", "limit": "30"]
    
    static var songs: [Song] = []{
        didSet{
            makeAlbumsFromSongs()
        }
    }
    
    static var arrayOfiTunesMedia: [StoreProtocol] = []
    
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
                self.songs = songs
                completion(songs)
            }
        }
    }
    
    static func makeAlbumsFromSongs(){
        for song in songs{
            let albumFromSong = Album(withSong: song) as StoreProtocol
            if !arrayOfiTunesMedia.contains(where: {$0 == albumFromSong}) {
                arrayOfiTunesMedia.append(albumFromSong)
            }
        }
        
        if songs.count > 10 {
            for x in 0...9{
                let song = songs[x]
                arrayOfiTunesMedia.append(song as StoreProtocol)
            }
        } else {
            for song in songs{
                arrayOfiTunesMedia.append(song as StoreProtocol)
            }
        }
    }
    
}
