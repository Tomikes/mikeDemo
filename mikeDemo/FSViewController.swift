//
//  FSViewController.swift
//  mikeDemo
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 Tomikes. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FSViewController: UIViewController, CLLocationManagerDelegate
{


    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        var point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(22.53705, 114.08248)
        point.title = "Nice Home"
        point.subtitle = "very good day!"
        
       // mapView.addAnnotation([Array]) 可以接入外部数据组
        
        mapView.addAnnotation(point)
        mapView.showAnnotations([point], animated: false)
        
        var initialLocation = CLLocation(latitude: 22.53705, longitude: 114.08248)
         centerMapOnLocation(initialLocation)
    }

    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
        
        mapView.showsUserLocation = true
        
        if let location = locationManager.location?.coordinate {
            
            mapView.setCenterCoordinate(location, animated: true)
            mapView.camera.altitude = pow(2, 11)
            
        } else {
            locationManager.startUpdatingLocation()
        }
        }
    }
    
    func  locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        if let location = locations.last as? CLLocation {
            mapView.setCenterCoordinate(location.coordinate, animated: true)
            mapView.camera.altitude = pow(2, 11)
        }
        
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var identifiler = "CustomAnnotation"
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        if annotation.isKindOfClass(MKPointAnnotation) {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifiler) as! MKPinAnnotationView!
            
            if pin == nil {
                
                //mark: 自定义显示pin
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifiler)
                pin.pinColor = .Green
                pin.calloutOffset = CGPoint(x: -5, y: 5)
                pin.animatesDrop = true
                pin.canShowCallout = true
                
                var button = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
                pin!.leftCalloutAccessoryView = button
                
                var image = UIImageView(image: UIImage(named: "ic_room"))
                
                pin!.rightCalloutAccessoryView = image
                
                
            } else {
                pin.annotation = annotation
            }
            
            return pin
            
        }
 
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control is UIButton {
            
            var alert = SCLAlertView()
            alert.showInfo("Hello", subTitle: "很高兴见到你")
            
            
            
        }
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    
}
