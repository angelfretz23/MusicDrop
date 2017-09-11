//
//  InstructionsPageViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/26/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class RedViewController: UIViewController{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .red
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
class BlueViewController: UIViewController{}

class InstructionsPageViewController: UIPageViewController {

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        setViewControllers([redVC], direction: .forward, animated: true, completion: nil)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let redVC: RedViewController  = {
        let vc = RedViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.view.backgroundColor = .white
        return vc
    }()
    
    let blueVC: BlueViewController = {
        let vc = BlueViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.view.backgroundColor = .blue
        return vc
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let subViews = view.subviews
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        
        for view in subViews {
            if view is UIScrollView {
                scrollView = view as? UIScrollView
            }
            else if view is UIPageControl {
                pageControl = view as? UIPageControl
                pageControl?.isEnabled = false
            }
        }
        
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubview(toFront: pageControl!)
        }
    }
}

extension InstructionsPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is RedViewController{
            return nil
        } else if viewController is BlueViewController {
            return self.redVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is RedViewController{
            return blueVC
        } else if viewController is BlueViewController {
            return nil
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
