//
//  TopChartsViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/12/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class TopChartsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchAppleMusicSearchBar: UISearchBar!
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setUpSearchController()
        setupSearchBar()
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TopChartsController.fetchSongs { (songs) in
            self.songs = songs
        }
    }
    
    var songs: [Song] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var itunesSongs: [Song] = []
    
    func setUpSearchController(){
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultsTVC")
        searchController = UISearchController(searchResultsController: resultsController)
        
        guard let searchController = searchController else { return }
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search iTunes"
        searchController.obscuresBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        view.addSubview(searchController.searchBar)
    }
    
    func setupSearchBar(){
        searchController?.searchBar.frame.origin = CGPoint(x: 0, y: 64)
        searchController?.searchBar.backgroundImage = #imageLiteral(resourceName: "searchBar")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mediaSelected"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                let dropSongVC = segue.destination as? DropSongViewController else { return }
            let song = self.songs[indexPath.row]
            dropSongVC.song = song
        }
        
        if segue.identifier == "mediaSelectedFromSearchController" {
            guard let dropSongVC = segue.destination as? DropSongViewController else { return }
            guard let sender = sender as? ResultsTableViewCell else { return }
            guard let indexPath = (searchController?.searchResultsController as? ResultsTableViewController)?.tableView.indexPath(for: sender) else { return }
            let index = (indexPath.section * ItunesSearchControllers.arrayOfItuneObjects.filter{$0.mediaType == "track"}.count) + indexPath.row
            guard let song = ItunesSearchControllers.arrayOfItuneObjects[index] as? Song else { return }
            dropSongVC.song = song
        }
        
        if segue.identifier == "albumDetailFromSearchController" {
            guard let albumVC = segue.destination as? AlbumViewController else { return }
            guard let sender = sender as? ResultsTableViewCell else { return }
            guard let indexPath = (searchController?.searchResultsController as? ResultsTableViewController)?.tableView.indexPath(for: sender) else { return }
            let index = (indexPath.section * ItunesSearchControllers.arrayOfItuneObjects.filter{$0.mediaType == "track"}.count) + indexPath.row
            guard let albumFromSong = ItunesSearchControllers.arrayOfItuneObjects[index] as? Album else { return }
            
            AlbumController.fetchSongsWithAlbum(ID: albumFromSong.storeID, completion: { (newAlbum) in
                guard let newAlbum = newAlbum else { print("albumIsNil"); return }
                DispatchQueue.main.async {
                    albumVC.album = newAlbum
                }
            })
            
        }
        
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension TopChartsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topChartCell", for: indexPath) as? TopChartsTableViewCell
        
        let song = self.songs[indexPath.row]
        cell?.updateWith(song: song, on: indexPath.row)
        
        return cell ?? TopChartsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        print(song.storeID)
        playSongWithID(id: song.storeID)
    }
    
    func playSongWithID(id: String...){
        musicPlayer.setQueueWithStoreIDs(id)
        musicPlayer.play()
    }
}

extension TopChartsViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension TopChartsViewController: UISearchControllerDelegate{
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.frame.origin = CGPoint(x: 0, y: 0)
        searchController.searchBar.barTintColor = UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.white
        searchController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        //searchController.searchBar.backgroundImage = #imageLiteral(resourceName: "searchBar")
    }
    func didPresentSearchController(_ searchController: UISearchController) {
        //searchController.searchBar.barTintColor = UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.white
        searchController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        //searchController.searchBar.backgroundImage = #imageLiteral(resourceName: "searchBar")
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.tintColor = UIColor.white
        searchController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        setupSearchBar()
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? ResultsTableViewController else { return }
        resultsController.songs = []
        resultsController.tableView.reloadData()
    }
    // TODO: make sure the cancel button is always white
}

extension TopChartsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let term = searchBar.text,
            let resultsController = searchController?.searchResultsController as? ResultsTableViewController else { return }
        
        ItunesSearchControllers.fetchSongs(with: term) { (songs) in
            guard let songs = songs else { return }
            self.itunesSongs = songs
            resultsController.songs = ItunesSearchControllers.arrayOfItuneObjects
            resultsController.tableView.reloadData()
        }
    }
}
