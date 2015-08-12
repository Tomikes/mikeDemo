//
//  ViewerViewController.swift
//  mikeDemo
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 Tomikes. All rights reserved.
//

import UIKit
import Alamofire

class ViewerViewController: UIViewController, UIScrollViewDelegate {
    
    
    //Mark: get value
    
    private var imageView = UIImageView()
    private var image: UIImage? {
        get {return imageView.image}
        set {
        
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            
        }
        
    }
    @IBAction func DownLoad(sender: AnyObject) {
        
        let alert = SCLAlertView()
        
        alert.addButton("Small Size") {
            
            self.git = Five100px.ImageSize.Tiny
            self.downloadPhoto()
        }
        alert.addButton("Middle Size") {
            self.git = Five100px.ImageSize.Medium
              self.downloadPhoto()
        }
        alert.addButton("Large Size") {
            self.git = Five100px.ImageSize.XLarge
            self.downloadPhoto()
        }
        alert.showSuccess("DownLoads", subTitle: "Please chose ImageSize!", closeButtonTitle: "Cancel")
        
        
        
    }

    func fetchImage() {
        if let id = photoID {
            
            spinner.startAnimating()
            
            Alamofire.request(Five100px.Router.PhotoInfo(id, .XLarge)).validate().responseObject{
                 (_, _, photoInfo: PhotoInfo?, error) in
                if error == nil {
                    self.photoInfo = photoInfo
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.title = photoInfo!.name
                    }
                    
                    
                    
                    Alamofire.request(.GET, photoInfo!.url).validate().responseImage{
                        (_, _, image, error) in
                        
                        if error == nil && image != nil {
                            self.image = image
                        } else {
                            println("error, \(error?.userInfo)")
                        }
                        
                    }
                    
                }
            }
        }
    }
    var photoID: Int?
    var photoInfo: PhotoInfo?
    
    
    var swaColor: UIColor = UIColor.redColor()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
   
    //mark: ScrollView
    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        
        self.git = Five100px.ImageSize.Large
        
        spinner.center = CGPoint(x: view.center.x, y: view.center.y - view.bounds.origin.y / 2.0)
        spinner.color = swaColor
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if image == nil {
            fetchImage()
            
        }
    }
    //MARK : Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var git = Five100px.ImageSize.Large
    
    
    //MARK: downLoad image
    func downloadPhoto() {
  
        
        // We already have the photoInfo but we prefer to request a new one with XLarge photo size URL
        Alamofire.request(Five100px.Router.PhotoInfo(photoInfo!.id, git)).validate().responseObject() {
            (_, _, photoInfo: PhotoInfo?, error) in
            
            if error == nil && photoInfo != nil {
                let imageURL = photoInfo!.url
                
                let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
                    (temporaryURL, response) in
                    
                    if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                        return directoryURL.URLByAppendingPathComponent("\(self.photoInfo!.id).\(response.suggestedFilename)")
                    }
                    
                    return temporaryURL
                }
                //下载进度条
                let progressIndicatorView = UIProgressView(frame: CGRect(x: 0.0, y: 80.0, width: self.view.bounds.width, height: 10.0))
                progressIndicatorView.tintColor = UIColor.greenColor()
                self.view.addSubview(progressIndicatorView)
                
                Alamofire.download(.GET, imageURL, destination).progress {
                    (_, totalBytesRead, totalBytesExpectedToRead) in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        progressIndicatorView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
                     
                        
                        let explode = ExplodeView(frame:CGRectMake(0, 50, 1,1))
                       progressIndicatorView.addSubview(explode)
                      
                        
                        if totalBytesRead == totalBytesExpectedToRead {
                            progressIndicatorView.removeFromSuperview()
                        }
                    }
                }
                
            }
        }
    }

}
