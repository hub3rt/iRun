//
//  CourseViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CourseViewController: ViewController, CLLocationManagerDelegate {

    let pinLocation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = 	self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways		)
        {
            centerMapOnLocation(location: locationManager.location!)
            mapView.addAnnotation(pinLocation)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnLocation(location: locationManager.location!)
    }
    
    public var regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        pinLocation.coordinate = location.coordinate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickStopBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Fin de course", message: "Voulez-vous arrêter votre course ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "non", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
            
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
