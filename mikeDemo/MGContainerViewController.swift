//
//  MGContainerViewController.swift
//  mikeDemo
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 Tomikes. All rights reserved.
//

import UIKit

class MGContainerViewController: UIViewController, UIScrollViewDelegate, YALTabBarInteracting
{


    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var menuContainerView: UIView!
    

    private var detailViewController: DetailViewController?
    
    var menuItem: NSDictionary? {
        didSet {
            hideOrShowMenu(false, animated: true)
            if let detailViewController = detailViewController {
                detailViewController.menuItem = menuItem
            }
        }
    }
    
    var showingMenu = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuContainerView.layer.anchorPoint = CGPointMake(1.0, 0.5)
        hideOrShowMenu(showingMenu, animated: false)
    }
    
    // MARK: ContainerViewController
    func hideOrShowMenu(show: Bool, animated: Bool) {
        let xOffset = CGRectGetWidth(menuContainerView.bounds)
        scrollView.setContentOffset(show ? CGPointZero : CGPointMake(xOffset, 0), animated: animated)
        showingMenu = show
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let multiplier = 1.0 / CGRectGetWidth(menuContainerView.bounds)
        let offset = scrollView.contentOffset.x * multiplier
        let fraction = 1.0 - offset
        //    println("didScroll offset \(offset)")
        menuContainerView.layer.transform = transformForFraction(fraction)
        menuContainerView.alpha = fraction
        
        if let detailViewController = detailViewController {
            if let rotatingView = detailViewController.hamburgerView {
                rotatingView.rotate(fraction)
            }
            

            
            
        }
        
        
        
        scrollView.pagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))
        
        let menuOffset = CGRectGetWidth(menuContainerView.bounds)
        showingMenu = !CGPointEqualToPoint(CGPoint(x: menuOffset, y: 0), scrollView.contentOffset)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailViewSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            detailViewController = navigationController.topViewController as? DetailViewController
        }
    }
    
    // MARK: - Private
    
    func transformForFraction(fraction:CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0;
        let angle = Double(1.0 - fraction) * -M_PI_2
        let xOffset = CGRectGetWidth(menuContainerView.bounds) * 0.5
        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
        let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
        return CATransform3DConcat(rotateTransform, translateTransform)
    }
    

    func extraLeftItemDidPress() {
        
        let infoTitle = "Found!"
        
        SCLAlertView().showInfo(infoTitle, subTitle: "第三视图，Found功能即将实现" )
        
    }
    
    func extraRightItemDidPress() {
        
        let infoTitle = "Message!"
        
        SCLAlertView().showInfo(infoTitle, subTitle: "第三视图，消息功能即将实现" )
        
        
    }
    
    
    
}
