import UIKit
import SVProgressHUD
import DropDown
import Material

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var addingImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        dropDown.anchorView = adTypeView
        dropDown.dataSource = ["Бігборд", "Сітілайт", "Газета", "Листівка", "Намет", "Транспорт", "Інше"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.adType.text = item
        }
        
        // Will set a custom width instead of the anchor view width
        dropDown.width = 200
        prepareSwitch()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        dropDown.hide()
    }
    
    @IBAction func saveAd(_ sender: Any) {
        
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
        collectionView.reloadData()
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
        cell.deleteImageButton?.tag = indexPath.row
        cell.deleteImageButton?.addTarget(self, action: #selector(deleteAdImage), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteAdImage(sender:UIButton) {
        let i : Int = sender.tag
        print("Delete \(i)")
        addingImages.remove(at:i)
        collectionView.reloadData()
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
        print("Switch changed state to: ", .on == state ? "on" : "off")
    }
}
