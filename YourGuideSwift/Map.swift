//
//  Trends.swift
//  Flock Mobile Application
//
//  Created by Finn Wolff on 1/29/17.
//  Copyright © 2017 FTW co. All rights reserved.
//
import UIKit
import MapKit

class Map: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
  
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var profileButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "mtn"), tag: 0)
        
   
        //this sets up highlight for tab bar items, initially black text, when selected blue for now, can change later
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for:.normal)
        
   // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for:.selected)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { print("not enabled"); return }
        mapView.showsUserLocation = true
    }


    
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        self.tabBarController?.tabBar.isHidden = false
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        profileButton.imageView?.contentMode = .scaleAspectFit
        
        
        //we'll use this as a quick tutorial for new users eventually
        
        /*
        if newUser == "yes" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "popup") as! USERPopupVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
        } */
        
        
    }
    
    //Setting up map & location zoom
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Here we add disclosure button inside annotation window
    
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        // guard let annotation = annotation as? CalloutPin else { return nil }
        let reuseId = "pin"
        if #available(iOS 11.0, *) {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            //as? MKMarkerAnnotationView
            
            if pinView == nil {
                //print("Pinview was nil")
                //  pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                pinView!.canShowCallout = true
                
                //if we want to add custom annotation image
                
                pinView!.image = UIImage(named: "OTee.png")
                
            }
            
            let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
            
            //pinView!.isEnabled = true
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = button
            // pinView?.detailCalloutAccessoryView = button
            
            
            return pinView
            
        }
            // if not iOS 11
        else {
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                //print("Pinview was nil")
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                
            }
            
            let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
            
            //pinView!.isEnabled = true
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = button
            // pinView?.detailCalloutAccessoryView = button
            
            
            return pinView
            // Fallback on earlier versions
        }
 
 */
    
    
        
        
        
        
    }







