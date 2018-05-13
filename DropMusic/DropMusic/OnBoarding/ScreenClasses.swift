//
//  ScreenClasses.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/13/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

// MARK: - BaseViewController
class BaseViewController: UIViewController{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    private func setupSubViews(){
        view.addSubview(imageView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
}

// MARK: - FirstScreen
class FirstScreenViewController: BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "Screen1")
    }
}

// MARK: - SecondScreen
class SecondScreenViewController: BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "Screen2")
    }
}

// MARK: - ThirdScreen
class ThirdScreenViewController: BaseViewController {
    
    lazy var enterUsernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.projectBlue
        label.text = "Enter your alias name"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.lightGray
        tf.textColor = .white
        tf.layer.cornerRadius = 5
        tf.keyboardAppearance = .dark
        tf.returnKeyType = .done
        return tf
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.projectBlue
        button.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "Screen3")
        setupSubViews()
    }

    private func setupSubViews() {
        [enterUsernameLabel,textField, button].forEach { (view) in
            self.view.addSubview(view)
        }
        view.addConstraint(NSLayoutConstraint(item: enterUsernameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraintsWithFormat(format: "H:[v0(>=200,<=300)]", views: textField)
        view.addConstraintsWithFormat(format: "H:[v0(v1)]", views: button, textField)
        view.addConstraintsWithFormat(format: "H:[v0(>=200,<=300)]", views: button)
        
        view.addConstraintsWithFormat(format: "V:|-200-[v0]-[v1(25)]-[v2(25)]",options: .alignAllCenterX, views: enterUsernameLabel, textField, button)
    }
    
    @objc private func doneButtonPressed(_ sender: Any) {
        if let username = textField.text, !username.isEmpty {
            UsernameController.shared.set(username: username, success: { (success) in
                if success {
                    let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
                    self.parent?.present(mainVC, animated: true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "lauchedBefore")
                }
            })
        }
    }
}

