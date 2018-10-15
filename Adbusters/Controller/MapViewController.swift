//
//  MapViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configMap()
        determinateCurrentLocation()

//        let userLocation = mapView.userLocation
//        let region = MKCoordinateRegion(center: (userLocation.location?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
////
//        mapView.setRegion(region, animated: true)
        
    }
    
    func configMap () {
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }
    
    func determinateCurrentLocation ()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            // If allow get location
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude - 0.005, userLocation.coordinate.longitude - 0.005);
        myAnnotation.title = "Current location"
        
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}
