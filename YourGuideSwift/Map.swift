//
//  Trends.swift
//  Flock Mobile Application
//
//  Created by Finn Wolff on 1/29/17.
//  Copyright © 2017 FTW co. All rights reserved.
//
import UIKit
import MapKit
import Parse

class Map: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {
    //ANNOTATION DECLARED
    let annotation = MKPointAnnotation()
    
    //Defines geoPoint as nil
    var geoPoint : CLLocationCoordinate2D! = nil
    
    //this defines where on the map these points will be placed
    let coords = [CLLocation(latitude: 40.588329, longitude: -111.638068),
                    CLLocation(latitude: 40.580932, longitude:  -111.657701),
                    CLLocation(latitude: 40.597826, longitude: -111.582990)]
    
    let titles = ["Alta", "Snowbird", "Brighton"]
  
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBAction func ToProfile(_ sender: Any) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    let locationManager = CLLocationManager()
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
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
    
    
    @IBAction func findGuide(_ sender: Any) {
        
        let test = PFObject(className: "userProfile")
        
        test["name"] = "Finn"
        
        test.saveInBackground()
        print("SAVED")
    }
    
    
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { print("not enabled"); return }
        mapView.showsUserLocation = true
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        addAnnotations(coords: coords)
        
        self.navigationController?.navigationBar.isHidden = true
        
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
    
    //here is a function that can take that array, and loops through each element and adds it as an annotation to the mapView
    func addAnnotations(coords: [CLLocation]) {
        
        var count = 0
        
        for coord in coords {
            
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude)
            
            let anno = MKPointAnnotation()
            
            anno.coordinate = CLLCoordType
            
            anno.title = titles[count]
            
            anno.subtitle = "Click for details"
            
            mapView.addAnnotation(anno)
            
            count += 1
            
        }
        
    }
    
    
    //adds annotations to the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
            
        }
            /*
            let pinIdent = "Pin"
            
            var pinView: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                
                pinView = dequeuedView
                
            } else {
                
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
                
            }
            
            return pinView
        }
 */
        
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
                
                pinView!.image = UIImage(named: "resortPin")
                
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







