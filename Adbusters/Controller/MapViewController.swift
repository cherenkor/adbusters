import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import ClusterKit

public let CKMapViewDefaultAnnotationViewReuseIdentifier = "annotation"
public let CKMapViewDefaultClusterAnnotationViewReuseIdentifier = "cluster"

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, AdvertiseDelegate {
    
    func addAdvertise (party: String, politician: String, type: String, date: String, comment: String, images: [UIImage]) {
        popupView.isHidden = false
        partyLbl.text = party == "Партія не вибрана" ? "" : party
        typeLbl.text = type
        dateLbl.text = convertDate(dateStr: date)
        adImage.image = images[0]
        currentAdsImages = images
        currentComment = comment
        currentPolitician = politician
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
    var timeFromNow = DispatchTime.now()
    var lastRequest = 0
    
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
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 300
        mapView.clusterManager.algorithm = algorithm
        mapView.clusterManager.marginFactor = 1
        mapView.clusterManager.maxZoomLevel = 300
        DispatchQueue.main.async {
            self.configMap()
            self.determinateCurrentLocation()
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
    
    func loadAds (_ lat: Double, _ lon: Double, _ radius: Double) {
        
//        getAds(url: "http://adbusters.chesno.org/ads/") { (json, error) in
//        http://127.0.0.1:8000/
//        https://f603cd4c.ngrok.io/
        let timeDispatch = timeFromNow + 3.0
        lastRequest += 1
        let currentRequest = lastRequest
        DispatchQueue.main.asyncAfter(deadline: timeDispatch, execute: {
            
            print("\(self.lastRequest == currentRequest)")
            if self.lastRequest == currentRequest {
                getAds(url: "http://adbusters.chesno.org/ads_read/?latitude=\(lat)&longitude=\(lon)&radius=\(radius)") { (json, error) in
                
                    if let error = error {
                        print("ERROR WAR", error)
        //                error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                        return
                    }
                    
                    if let jsonData = json {
                        adsAll = jsonData
                        self.setPinsOnMap(jsonData: jsonData)
                    } else {
                        print("ERROR WAR")
                    }
                }
            }
        })
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
}

// MAP VIEW
extension MapViewController {
    
    func setPinsOnMap (jsonData: [AdModel]) {
        var annotations = [MyAnnotation]()
        for ad in jsonData {
            let annotation = self.setPin(id: ad.id!, latitude: ad.latitude!, longitude: ad.longitude!, party: ad.party?.name ?? "", politician: ad.person?.name ?? "", date: ad.created_date ?? "", comment: ad.comment ?? "", type: ad.type ?? 7, images: ad.images ?? [AdImage]())
            annotations.append(annotation)
        }
        //        self.mapView.addAnnotations(annotaions)
        DispatchQueue.main.async {
            self.mapView.clusterManager.annotations = annotations
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
    
    func setPin (id: Int, latitude: Double, longitude: Double, party: String, politician: String, date: String, comment: String, type: Int, images: [AdImage]) -> MyAnnotation {
        let marker = MyAnnotation(id: id, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), party: party, politician: politician, date: date, comment: comment, type: type, images: images)
        return marker
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
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius //  radius / 1000.0 - if you want to convert radius to meters
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let cluster = annotation as? CKCluster else {
            return nil
        }
        
//        let ann = cluster.annotations as! [MyAnnotation]
//        for an in ann {
//            print(an.party!)
//        }
        
        if cluster.count > 1 {
            return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier) ??
                CKClusterView(annotation: annotation, reuseIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        
        return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier) ??
            CKAnnotationView(annotation: annotation, reuseIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    // MARK: - How To Update Clusters
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        let centralLocation = CLLocation(latitude: lat, longitude: lon)
        centralLocationCoordinate = mapView.centerCoordinate
        let radius = self.getRadius(centralLocation: centralLocation)
//        print("Lat - \(lat), Lon - \(lon), Radius - \(radius)")

//        DispatchQueue.main.async {
//            let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
//            algorithm.cellSize = CGFloat(radius)
//            mapView.clusterManager.algorithm = algorithm
//            mapView.clusterManager.marginFactor = 1
//            self.loadAds(lat, lon, radius)
//        }
        timeFromNow = DispatchTime.now()
        loadAds(lat, lon, radius)
        mapView.clusterManager.updateClustersIfNeeded()
    }
    
    // MARK: - How To Handle Selection/Deselection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cluster = view.annotation as? CKCluster else {
            return
        }
        
        if getAdstask != nil {
            getAdstask!.cancel()
        }
        
        if cluster.count > 1 {
//            let edgePadding = UIEdgeInsets(top: 40, left: 20, bottom: 44, right: 20)
//            mapView.show(cluster, edgePadding: edgePadding, animated: true)
            let markersData = cluster.annotations as! [MyAnnotation]
            
            for marker in markersData {
                multipleMarkerDate.append(AdModel(id: marker.id!, images: marker.images, comment: marker.comment ?? "", type: marker.type ?? 7, party: marker.party ?? "", politician: marker.politician ?? "", date: marker.date!))
            }
            performSegue(withIdentifier: "goToMultipleMarkersView", sender: nil)
        } else if let annotation = cluster.firstAnnotation as? MyAnnotation {
            setSingleMarkerData(party: annotation.party!, politician: annotation.politician!, date: annotation.date!, comment: annotation.comment!, type: annotation.type!, images: annotation.images)
            mapView.clusterManager.selectAnnotation(annotation, animated: false);
            performSegue(withIdentifier: "goToSingleMarkerView", sender: nil)
            mapView.clusterManager.deselectAnnotation(annotation, animated: false);
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let cluster = view.annotation as? CKCluster, cluster.count == 1 else {
            return
        }
        
        mapView.clusterManager.deselectAnnotation(cluster.firstAnnotation, animated: false);
    }
    
    // MARK: - How To Handle Drag and Drop
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let cluster = view.annotation as? CKCluster else {
            return
        }
        
        switch newState {
        case .ending:
            
            if let annotation = cluster.firstAnnotation as? MKPointAnnotation {
                annotation.coordinate = cluster.coordinate
            }
            
            view.setDragState(.none, animated: true)
            
        case .canceling:
            view.setDragState(.none, animated: true)
            
        default: break
            
        }
    }
}

class CKAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        isDraggable = true
        image = getResizedMarker (UIImage(named: "marker")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}

class CKClusterView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = getResizedMarker(UIImage(named: "marker_group")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
