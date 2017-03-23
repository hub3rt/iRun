//
//  CourseViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class CourseViewController: ViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let pinLocation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    public var isVoiceActive = false
    private var locationsA:[CLLocationCoordinate2D] = []
    private var timer = Timer()
    @IBOutlet weak var chronoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    private var distance = 0.0
    private var temps = 0.0000
    private var lastTime: NSDate = NSDate()
    private var timeNow: NSDate = NSDate()
    
    private var heures = 0
    private var minutes = 0
    private var secondes = 0
    
    public var typeDeRun = TypeDeCourse()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        locationManager.delegate = 	self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        locationsA = []
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            centerMapOnLocation(location: locationManager.location!)
            mapView.addAnnotation(pinLocation)
        }
        
        distance = 0.0
        temps = 0.0000
        heures = 0
        minutes = 0
        secondes = 0
        lastTime = NSDate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(CourseViewController.update), userInfo: nil, repeats: true)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnLocation(location: locationManager.location!)
        if (locationsA.count > 1)
        {
            let dist = CLLocation(latitude: locationsA[locationsA.count - 1].latitude, longitude: locationsA[locationsA.count - 1].longitude).distance(from: CLLocation(latitude: locationsA[locationsA.count - 2].latitude, longitude: locationsA[locationsA.count - 2].longitude))
            distance = distance + (Double(dist) / 1000.0)
            
            let km = Int(distance)
            let m = Int((distance - Double(km)) * 100.0)
            
            distanceLabel.text = "\(km),\(m < 10 ? "0\(m)" : String(m)) km"
            
            var speed: CLLocationSpeed = CLLocationSpeed()
            speed = locationManager.location!.speed
            
            speedLabel.text = String(format: "%.0f km/h", speed * 3.6)
        }
    }
    
    public var regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        pinLocation.coordinate = location.coordinate
        locationsA.append(location.coordinate)
        
        mapView.removeOverlays(mapView.overlays)
        
        let polyline = MKPolyline(coordinates: &locationsA, count: locationsA.count)
        mapView.add(polyline)
    }
    
    func update(){
        secondes = secondes + 1
        
        if (secondes == 60) {
            minutes += 1
            secondes = 0
        }
        
        if (minutes == 60) {
            heures += 1
            minutes = 0
        }
        
        chronoLabel.text = "\(heures < 10 ? "0\(heures)" : String(heures)):\(minutes < 10 ? "0\(minutes)" : String(minutes)):\(secondes < 10 ? "0\(secondes)" : String(secondes))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickStopBtn(_ sender: UIButton) {
        
        timer.invalidate()
        
        locationManager.stopUpdatingLocation()
        
        let alertController = UIAlertController(title: "Fin de course", message: "Voulez-vous arrêter votre course ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Non", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
            self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(CourseViewController.update), userInfo: nil, repeats: true)
            self.locationManager.startUpdatingLocation()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            let context = self.getContext()
            
            let newCourse = Course(context: context)
            newCourse.date = NSDate()
            newCourse.distance = NSDecimalNumber(value: self.distance)
            self.temps = Double(self.heures) + (Double(self.minutes) / 100.0) + (Double(self.secondes) / 10000.0)
            newCourse.duree = NSDecimalNumber(value: self.temps)
            let avgSpeed = self.distance / (Double(self.heures) + (Double(self.minutes) / 60.0) + (Double(self.secondes) / 3600.0))
            newCourse.vitesse = NSDecimalNumber(value: avgSpeed)
            newCourse.type = self.typeDeRun
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }

            self.performSegue(withIdentifier: "backToHome", sender: self)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
}
