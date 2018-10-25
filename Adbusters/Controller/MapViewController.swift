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
    
    
    @IBAction func deleteAdImage(_ sender: Any) {
        print("DELETE SINGLE AD IMAGE")
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
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
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
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        } else {
            SVProgressHUD.showError(withStatus: "Дозвольте визначити вашi координати")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
        
//        DispatchQueue.main.async {
//            self.locationManager.startUpdatingLocation()
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        manager.stopUpdatingLocation()
    }
    
}
