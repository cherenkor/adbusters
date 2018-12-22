import UIKit
import SVProgressHUD
import DropDown
import Material
import Photos

protocol AdvertiseDelegate {
    func addAdvertise(party: String, politician: String, type: String, date: String, comment: String, images: [UIImage])
}

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PoliticianDelegate, PartyDelegate, LocationDelegate {
    
    var delegate: AdvertiseDelegate?
    
    func haveParty(partyName: String) {
        if partyName != "" {
            partyLabel.text = partyName
            partyLabel.textColor = .black
        } else {
            SVProgressHUD.showError(withStatus: "Партію не обрано")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func havePolitician(politicianName: String) {
        if politician != "" {
            politicianLabel.text = politicianName
            politicianLabel.textColor = .black
        } else {
            SVProgressHUD.showError(withStatus: "Політика не обрано")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func haveManualLocation(street: String, city: String, country: String) {
        currentLocation = "\(street), \(city), \(country)"
        adLocation.text = currentLocation
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var addingImages = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var control: Switch?
    var party: String?
    var politician: String?
    var requiredLocation = true
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var politicianLabel: UILabel!
    
    @IBOutlet weak var commentLbl: UITextField!
    
    @IBOutlet weak var adLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UIView()
        let width = CGFloat(0.5)
        line.frame = CGRect(x: 0, y: commentLbl.frame.size.height - width, width:  commentLbl.frame.size.width, height: 1.0)
//        line.frame.origin = CGPoint(x: 0, y: commentLbl.frame.maxY - line.frame.height)
        line.backgroundColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        commentLbl.addSubview(line)
        commentLbl.tintColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        self.adLocation.text = currentLocation
        
        DispatchQueue.main.async{
            self.presentImagePicker()
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            
            self.dropDown.anchorView = self.adTypeView
            self.dropDown.dataSource = ["Бігборд", "Сітілайт", "Газета", "Листівка", "Намет", "Транспорт", "Інше"]
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if item == "Газета" {
                    self.requiredLocation = false
                    self.commentLbl.placeholder = "Вкажiть тираж"
                    currentLocation = nil
                    currentLatitude = nil
                    currentLongitude = nil
                    self.adLocation.text = ""
                    self.control!.setSwitchState(state: .off)
                    self.chooseLocationView.isHidden = true
                } else {
                    self.requiredLocation = true
                }
                self.adType.text = item
            }
            
            // Will set a custom width instead of the anchor view width
            self.dropDown.width = 200
            self.prepareSwitch()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "party" {
            let partiesVC = segue.destination as! PartiesViewController
            partiesVC.delegate = self
        } else if segue.identifier == "politician" {
            let politicianVC = segue.destination as! PoliticiansViewController
            politicianVC.delegate = self
        } else if segue.identifier == "location" {
            let locationVC = segue.destination as! AddCustomLocationViewController
            locationVC.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        dropDown.hide()
    }
    
    @IBAction func saveAd(_ sender: Any) {
        SVProgressHUD.show()
        
        if addingImages.count == 0 {
            SVProgressHUD.showError(withStatus: "Додайте фото")
            SVProgressHUD.dismiss(withDelay: 1.0)
            return
        }
        
        if requiredLocation && (currentLocation == "" || currentLatitude == nil || currentLongitude == nil) {
            SVProgressHUD.showError(withStatus: "Укажiть мiсце знаходження")
            SVProgressHUD.dismiss(withDelay: 1.0)
            return
        }
        
        let date = getDateNow()
        adsAll = [AdModel]()
        currentComment = commentLbl.text
        currentType = adType.text!
        currentAdsImages = addingImages
        
        uploadImages { noErrors in
            DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            
                if noErrors == true {
                    self.delegate?.addAdvertise(party: self.partyLabel.text ?? "", politician: self.politicianLabel.text ?? "", type: self.adType.text!, date: date, comment: self.commentLbl.text ?? "", images: self.addingImages )
                    currentLocation = ""
                    currentLongitude = nil
                    currentLatitude = nil
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Toast().alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                }
            }
        }
    }
    
    // Adding image
    @IBAction func addAdImage(_ sender: Any) {
        presentImagePicker()
    }
    
    func presentImagePicker () {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Спосіб завантаження", message: "Виберіть спосіб завантаження", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera ) {
                imageController.sourceType = .camera
                self.present(imageController, animated: true, completion: nil)
            } else {
                SVProgressHUD.showError(withStatus: "Камера недоступна")
                SVProgressHUD.dismiss(withDelay: 1.0)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (UIAlertAction) in
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary ) {
                        imageController.sourceType = .photoLibrary
                        self.present(imageController, animated: true, completion: nil)
                    } else {
                        SVProgressHUD.showError(withStatus: "Галерея недоступна")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                    }
                    
                   
                } else {
                    Toast().alert(with: self, title: "Помилка доступу", message: "Надайте доступ до фото та камери вручну")
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Відмінити", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            if let location = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)[0].location {
                currentLatitude = location.coordinate.latitude
                currentLongitude = location.coordinate.longitude
                let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                getAdress (location) { address, error in
                    if let a = address, let street = a["Street"] as? String, let city = a["City"] as? String, let country = a["Country"] as? String {
                        currentLocation = "\(street), \(city), \(country)"
                        self.adLocation.text = currentLocation
                    } else {
                        currentLocation = "Невiдомо"
                    }
                }
            }
        }
        
        addingImages.append(image!)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addingImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddAdImageViewCollectionViewCell
        cell.adImageView.image = addingImages[indexPath.row]
        cell.imageIndex = indexPath.row
        cell.deleteImageClb = {imageIndex in
            self.addingImages.remove(at: imageIndex)
        }
        return cell
    }
    
    @objc func deleteAdImage(sender:UIButton) {
        let i : Int = sender.tag
        addingImages.remove(at:i)
    }
    
    // Ads type picker
    
    @IBOutlet weak var adTypeView: UIView!
    
    var dropDown = DropDown()
    @IBOutlet weak var adType: UILabel!
    
    @IBAction func showDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    // User current location
    @IBOutlet weak var userLocationSwitchView: UIView!
    
    @IBOutlet weak var chooseLocationView: UIView!
    
}



extension AddAdsViewController {
    fileprivate func prepareSwitch() {
        control = Switch(state: .on, style: .light, size: .small)
        control!.delegate = self
        control!.buttonOnColor = UIColor(red:0.36, green:0.82, blue:0.67, alpha:1.0)
        control!.buttonOffColor = .white
        control!.trackOnColor = UIColor(red:0.80, green:0.93, blue:0.88, alpha:1.0)
        control!.trackOffColor = .gray
        
        userLocationSwitchView.layout(control!).center()
    }
}

extension AddAdsViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        chooseLocationView.isHidden = .off == state
    }
}
