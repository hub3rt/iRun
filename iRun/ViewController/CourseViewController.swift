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

class CourseViewController: ViewController {

    var kLongitude = 0.0;
    var kLatitude = 0.0;
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = 	self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse		)
        {
            print(locationManager.location)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var stopBtn: UIButton!
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager();
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        kLongitude = Double(userLocation.coordinate.longitude);
        kLatitude = Double(userLocation.coordinate.latitude);
    }
}
