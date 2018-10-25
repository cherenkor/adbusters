import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

typealias JSONDictionary = [String:Any]

protocol LocationDelegate {
    func haveManualLocation(street: String, city: String, country: String)
}

class AddCustomLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var delegate: LocationDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var location = [String:String]()
    
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        currentLocationLbl.backgroundColor = UIColor.white
        
        configMap()
        determinateCurrentLocation()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
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
        }  else {
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
            mapView.setRegion(region, animated: true)
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.showError(withStatus: "Не можу оновити мiсцезнаходження")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        manager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getAdress { address, error in
            if let a = address, let street = a["Street"] as? String, let city = a["City"] as? String, let country = a["Country"] as? String {
                self.currentLocationLbl.text = "\(street), \(city), \(country)"
                self.delegate?.haveManualLocation(street: street, city: city, country: country)
            } else {
                currentLocation = "Невiдомо"
            }
        }
    }
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        let centerPosition = self.mapView.centerCoordinate
        let currentLocation =  CLLocation(latitude: centerPosition.latitude, longitude: centerPosition.longitude)
            
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
