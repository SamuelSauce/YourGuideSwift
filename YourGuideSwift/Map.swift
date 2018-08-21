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
import Alamofire
class Map: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {
    //ANNOTATION DECLARED
    let annotation = MKPointAnnotation()
    
    //Defines geoPoint as nil
    var geoPoint : CLLocationCoordinate2D! = nil
    
    //sets titles for given coords
    let titles = ["Alta", "Snowbird", "Brighton", "Solitude", "Park City Mountain Resort", "Deer Valley", "Snowbasin", "Jackson Hole Ski Area", "Sun Valley", "Aspen Highlands Ski Resort", "Breckenridge", "Steamboat", "Telluride", "Keystone", "Mammoth", "Bear Mountain Ski Resort", "Squaw Valley"]

    @IBOutlet weak var guidingSwitch: UISwitch!
    @IBOutlet weak var findGuideButton: UIButton!
    
    @IBAction func guidingOn(_ sender: Any) {
        PFUser.current()!["isGuiding"] = guidingSwitch.isOn
        PFUser.current()!.saveInBackground()
        if PFUser.current()!["isGuiding"] as! Bool == true{
            findGuideButton.backgroundColor = UIColor.blue
            findGuideButton.setTitle("Guiding", for: .normal)
        }else{
            findGuideButton.backgroundColor = UIColor.black
            findGuideButton.setTitle("Find a Guide", for: .normal)
        }
    }
    //Resorts added to the map
    let Alta = CLLocation(latitude: 40.588329, longitude: -111.638068)
    
    let Snowbird = CLLocation(latitude: 40.580932, longitude:  -111.657701)
    
    let Brighton = CLLocation(latitude: 40.597826, longitude: -111.582990)
    
    let Solitude = CLLocation(latitude: 40.619873, longitude: -111.591645)
    
    let ParkCity = CLLocation(latitude: 40.651323, longitude: -111.508058)
    
    let DeerValley = CLLocation(latitude: 40.637331, longitude: -111.478478)
    
    let SnowBasin = CLLocation(latitude: 41.215875, longitude: -111.856886)
    
    let Jackson = CLLocation(latitude: 43.586730, longitude: -110.827388)
    
    let SunValley = CLLocation(latitude: 43.671079, longitude: -114.367772)
    
    let AspenHighlands = CLLocation(latitude: 39.182223, longitude: -106.855618)
    
    let Breckenridge = CLLocation(latitude: 39.480112, longitude: -106.066537)
    
    let Steamboat = CLLocation(latitude: 40.457109, longitude: -106.804608)
    
    let Telluride = CLLocation(latitude: 37.936742, longitude: -107.846860)
    
    let Keystone = CLLocation(latitude: 39.604678, longitude: -105.954873)
    
    let Mammoth = CLLocation(latitude: 37.651380, longitude: -119.037941)
    
    let BearMountain = CLLocation(latitude: 34.227627, longitude: -116.860907)
    
    let SquawValley = CLLocation(latitude: 39.197448, longitude: -120.235457)
    

    @IBOutlet weak var locationButton: UIButton!
    
    @IBAction func locationChooser(_ sender: Any) {
        var locationVC = self.storyboard?.instantiateViewController(withIdentifier: "locationViewController") as! UIViewController
        self.navigationController?.present(locationVC, animated: true, completion: nil)
    }
    
    
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
        sendPush()
    }
    
    
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current()!["isGuide"] as! Bool == false{
            guidingSwitch.isHidden = true
        }else{
            guidingSwitch.isHidden = false
        }
        self.navigationController?.navigationBar.isHidden = true
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        var user = PFUser.query()
        
        user?.whereKey("username", equalTo: PFUser.current()?.username)
        
        user?.findObjectsInBackground(block: { (objects, error) in
            
            if let persons = objects {
                
                for object in persons {
                    
                    if let person = object as? PFObject {
                        
                        self.locationButton.setTitle((person["resort"] as! String), for: .normal)
                        
                        
                    }
                    
                }
                
                
            }
            
        })
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { print("not enabled"); return }
        mapView.showsUserLocation = true
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.query()
        
        user?.whereKey("username", equalTo: PFUser.current()?.username)
        
        user?.findObjectsInBackground(block: { (objects, error) in
            
            if let persons = objects {
                
                for object in persons {
                    
                    if let person = object as? PFObject {
                        
                        self.locationButton.setTitle((person["resort"] as! String), for: .normal)
                        
                        
                    }
                    
                }
                
                
            }
            
        })
        locationButton.layer.cornerRadius = 10
        locationButton.clipsToBounds = true
        locationButton.layer.borderWidth = 1
        locationButton.layer.borderColor = UIColor.black.cgColor
        //this defines where on the map these points will be placed
        let coords = [Alta, Snowbird, Brighton, Solitude, ParkCity, DeerValley, SnowBasin, Jackson, SunValley, AspenHighlands, Breckenridge, Steamboat, Telluride, Keystone, Mammoth, BearMountain, SquawValley]

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
        
        let userLocation: CLLocation = locationManager.location!
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
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
                
                pinView!.image = UIImage(named: "tram")
                
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
    
    /*
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
        
        
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendPush(){
        let resortString: String = locationButton.title(for: .normal)!
        
        PFCloud.callFunction(inBackground: "findGuide", withParameters: ["resort":resortString]) { (response, error) in
            if let error = error {
                //If it fails, maybe display a message with code inside here
                print(error.localizedDescription)
            } else {
                //else it was successful, maybe display "success, email sent" on screen here.
                let responseString = response as? String
                print(responseString)
            }
            
        }
        
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







