//
//  InstructionsPageViewController.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/26/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class InstructionsPageViewController: UIPageViewController {

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        setViewControllers([firstScreenVC], direction: .forward, animated: true, completion: nil)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let firstScreenVC: FirstScreenViewController  = {
        let vc = FirstScreenViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.view.backgroundColor = .white
        return vc
    }()
    
    let secondScreenVC: SecondScreenViewController = {
        let vc = SecondScreenViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.view.backgroundColor = .blue
        return vc
    }()
    
    let thirdScreenVC: ThirdScreenViewController = {
        let vc = ThirdScreenViewController()
        vc.view.frame = UIScreen.main.bounds
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension InstructionsPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is FirstScreenViewController{
            return nil
        } else if viewController is SecondScreenViewController {
            return firstScreenVC
        } else if viewController is ThirdScreenViewController {
            return secondScreenVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is FirstScreenViewController{
            return secondScreenVC
        } else if viewController is SecondScreenViewController {
            return thirdScreenVC
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
