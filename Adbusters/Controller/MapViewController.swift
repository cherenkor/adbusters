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
import SVProgressHUD

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, AdvertiseDelegate {
    
    func addAdvertise (party: String, politician: String, type: String, date: String, images: [UIImage]) {
        print("Done with \(party)")
        popupView.isHidden = false
        partyLbl.text = party
        typeLbl.text = type
        dateLbl.text = date
        adImage.image = images[0]
        currentAdsImages = images 
    }
    
    @IBAction func addAdButtonPressed(_ sender: Any) {
        if isLogged == false {
            SVProgressHUD.showError(withStatus: "Спочатку увiйдiть")
            SVProgressHUD.dismiss(withDelay: 1.0) {
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "goToAddAds", sender: self)
        }
    }
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var partyLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var currentAdView: UIView!

    @objc func showSingleAd(_ sender:UITapGestureRecognizer){
        currentParty = partyLbl.text
        currentType = typeLbl.text
        currentDate = dateLbl.text
        performSegue(withIdentifier: "goToSingleAd", sender: nil)
    }

    @IBAction func closePopup(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.popupView.alpha = 0.0
        }) { (isCompleted) in
            self.popupView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddAds" {
            let addAds = segue.destination as! AddAdsViewController
            addAds.delegate = self
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBAction func logoPressed(_ sender: Any) {
        let url = URL(string: "http://chesno.org")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        SVProgressHUD.show()
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.showSingleAd (_:)))
        currentAdView.addGestureRecognizer(gesture)
        
        configMap()
        determinateCurrentLocation()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)

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
        locationManager.requestLocation()
        
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
        manager.stopUpdatingLocation()
        SVProgressHUD.dismiss()
        
        // Drop a pin at user's Current Location
//        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude - 0.005, userLocation.coordinate.longitude - 0.005);
//        myAnnotation.title = "Current location"
//
//        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
        SVProgressHUD.dismiss(withDelay: 1.0)
        manager.stopUpdatingLocation()
    }
    
}
