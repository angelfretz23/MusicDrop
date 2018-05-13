//
//  DrawerViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 5/11/18.
//  Copyright © 2018 Angel Contreras. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    var musicPlayerView: MusicPlayerView = {
        let mPV = MusicPlayerView(frame: .zero)
        mPV.backgroundColor = .clear//UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        mPV.autoresizesSubviews = true
        return mPV
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var gripperView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var songs: [Song] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let mainVC = self.pulleyViewController?.primaryContentViewController as? MainViewController {
            mainVC.delegate = self
        }
    }
    
    private func setupViews() {
        [musicPlayerView, tableView, gripperView].forEach { (view) in
            self.view.addSubview(view)
        }
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: musicPlayerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0(68)][v1]|", views: musicPlayerView, tableView)
        
        //gripper
        view.addConstraintsWithFormat(format: "H:[v0(36)]", views: gripperView)
        view.addConstraintsWithFormat(format: "V:|-8-[v0(5)]", views: gripperView)
        gripperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gripperView.layer.cornerRadius = 2.5
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dropSong")
        tableView.backgroundColor = .clear//UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.8)
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = self.view.bounds
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
        
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    }
    
}

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropSong", for: indexPath)
        let song = songs[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text
            = song.songName
        cell.detailTextLabel?.text = song.artistName
        cell.detailTextLabel?.textColor = .projectBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
}

extension DrawerViewController: MainViewControllerDelegate {
    func didDeselectClusterAnnotation() {
        songs.removeAll()
        pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
    }
    
    func didSelectClusterAnnotation(with songAnnotations: [SongAnnotation]) {
        self.songs = songAnnotations.compactMap { $0.dropSong?.song }
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
}
