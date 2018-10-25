import UIKit
import SVProgressHUD
import DropDown
import Material

protocol AdvertiseDelegate {
    func addAdvertise(party: String, politician: String, type: String, date: String, images: [UIImage])
}

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PoliticianDelegate, PartyDelegate, LocationDelegate {
    
    var delegate: AdvertiseDelegate?
    
    func haveParty(partyName: String) {
        print(partyName)
        if partyName != "" {
            partyLabel.text = partyName
            partyLabel.textColor = .black
        } else {
            print("No party")
            SVProgressHUD.showError(withStatus: "Партію не обрано")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func havePolitician(politicianName: String) {
        if politician != "" {
            politicianLabel.text = politicianName
            politicianLabel.textColor = .black
        } else {
            print("No politician")
            SVProgressHUD.showError(withStatus: "Політика не обрано")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    func haveManualLocation(street: String, city: String, country: String) {
        adLocation.text = "\(street), \(city), \(country)"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var addingImages = [UIImage]() {
        didSet {
            collectionView.reloadData()
            print("Images updated")
        }
    }
    
    var party: String?
    var politician: String?
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var politicianLabel: UILabel!
    @IBOutlet weak var adLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        dropDown.anchorView = adTypeView
        dropDown.dataSource = ["Бігборд", "Сітілайт", "Газета", "Листівка", "Намет", "Транспорт", "Інше"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.adType.text = item
        }
        
        // Will set a custom width instead of the anchor view width
        dropDown.width = 200
        prepareSwitch()
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
        print("Pa \(String(describing: partyLabel.text)), po \(String(describing: politicianLabel.text)), co \(addingImages.count)")
        if partyLabel.text == nil || politicianLabel.text == nil || addingImages.count == 0 || adType.text == nil {
            SVProgressHUD.showError(withStatus: "Заповнiть усi поля")
            SVProgressHUD.dismiss(withDelay: 1.0)
        } else {
            delegate?.addAdvertise(party: partyLabel.text!, politician: politicianLabel.text!, type: adType.text!, date: "12 жов, 2019", images: addingImages )
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Adding image
    @IBAction func addAdImage(_ sender: Any) {
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
                print("Camera is not available")
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (UIAlertAction) in
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Відмінити", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
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
        print("Delete \(i)")
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
        let control = Switch(state: .on, style: .light, size: .small)
        control.delegate = self
        control.buttonOnColor = UIColor(red:0.36, green:0.82, blue:0.67, alpha:1.0)
        control.buttonOffColor = .white
        control.trackOnColor = UIColor(red:0.80, green:0.93, blue:0.88, alpha:1.0)
        control.trackOffColor = .gray
        
        userLocationSwitchView.layout(control).center()
    }
}

extension AddAdsViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        chooseLocationView.isHidden = .off == state
    }
}
