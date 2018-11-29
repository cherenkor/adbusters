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
    
    func addAdvertise (party: String, politician: String, type: String, date: String, comment: String, images: [UIImage]) {
        popupView.isHidden = false
        partyLbl.text = party == "Партія не вибрана" ? "" : party
        typeLbl.text = type
        dateLbl.text = convertDate(dateStr: date)
        adImage.image = images[0]
        currentAdsImages = images
        currentComment = comment
        currentPolitician = politician == "Політик не вибраний" ? "" : politician
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
    var currentPolitician = ""
    
    @IBOutlet weak var currentAdView: UIView!
    var centralLocationCoordinate : CLLocationCoordinate2D?

    @objc func showSingleAd(_ sender:UITapGestureRecognizer){
        loadedAds = false
        isAddAdsView = true
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
            setCurrentAdress()
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 0.8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.showSingleAd (_:)))
        currentAdView.addGestureRecognizer(gesture)
        
        DispatchQueue.main.async {
            self.configMap()
            self.determinateCurrentLocation()
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
    
    func loadAds (_ lat: Double, _ lon: Double, _ radius: Double) {
        if let adsExist = adsAll {
            setPinsOnMap(jsonData: adsExist)
        }
        
//        getAds(url: "http://adbusters.chesno.org/ads/") { (json, error) in
        getAds(url: "http://127.0.0.1:8000/ads_read/?latitude=\(lat)&longitude=\(lon)&radius=\(radius)") { (json, error) in
        
            if let error = error {
                print("ERROR WAR", error)
                error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                return
            }
            
            if let jsonData = json {
                adsAll = jsonData
                self.setPinsOnMap(jsonData: jsonData)
            } else {
                error?.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
            }
        }
    }
    
    func setPinsOnMap (jsonData: [AdModel]) {
        var annotaions = [MyAnnotation]()
        for ad in jsonData {
            let annotation = self.setPin(id: ad.id!, latitude: ad.latitude!, longitude: ad.longitude!, grouped: ad.grouped!)
            annotaions.append(annotation)
        }
        self.mapView.addAnnotations(annotaions)
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
            SVProgressHUD.dismiss(withDelay: 0.8)
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            setCurrentAdress()
            mapView.setRegion(viewRegion, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 0.8)
        }
    }
    
    func setPin (id: Int, latitude: Double, longitude: Double, grouped: Bool) -> MyAnnotation {
        let marker = MyAnnotation(id: id, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), grouped: grouped)
        return marker
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let myAnnotation = view.annotation as? MyAnnotation{
            print("ad with id - \(String(describing: myAnnotation.id!))");
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MyAnnotation {
            let identifier = "identifier"
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = annotation.image //add this
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -2, y: 2)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            return annotationView
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            setCurrentAdress()
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 0.8)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        manager.stopUpdatingLocation()
    }
    
    func setCurrentAdress () {
        
        getAdress { address, error in
            if let a = address, let street = a["Street"] as? String, let city = a["City"] as? String, let country = a["Country"] as? String {
                currentLocation = "\(street), \(city), \(country)"
            } else {
                currentLocation = "Невiдомо"
            }
        }
    }
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        if let currentLocation = self.locationManager.location {
        
            let geoCoder = CLGeocoder()
        
            geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    let placeArray = placemarks
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                
                }
            
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        let centralLocation = CLLocation(latitude: lat, longitude: lon)
        centralLocationCoordinate = mapView.centerCoordinate
        let radius = self.getRadius(centralLocation: centralLocation)
        print("Lat - \(lat), Lon - \(lon), Radius - \(radius)")
        
        DispatchQueue.main.async {
            self.loadAds(lat, lon, radius)
        }
    }
    
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius //  radius / 1000.0 - if you want to convert radius to meters
    }
}
