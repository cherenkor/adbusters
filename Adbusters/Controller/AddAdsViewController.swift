import UIKit
import SVProgressHUD

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDropDownTextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var addingImages = [UIImage]()
    var adType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        dropTextField.dropDownDelegate = self
        dropTextField.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        let bigboard = UIDropDownObject(title: "Бігборд", value: "Бігборд", icon: nil)
        let cityLight = UIDropDownObject(title: "Сітілайт", value: "Сітілайт", icon: nil)
        let newspaper = UIDropDownObject(title: "Газета", value: "Газета", icon: nil)
        let paper = UIDropDownObject(title: "Листівка", value: "Листівка", icon: nil)
        let camp = UIDropDownObject(title: "Намет", value: "Намет", icon: nil)
        let transport = UIDropDownObject(title: "Транспорт", value: "Транспорт", icon: nil)
        let other = UIDropDownObject(title: "Інше", value: "Facebook", icon: nil)
        adsTypeList = [bigboard, cityLight, newspaper, paper, camp, transport, other]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    @IBOutlet var dropTextField: UIDropDownTextField!
     var adsTypeList: [UIDropDownObject] = [UIDropDownObject]()
    
    func dropDownTextField(_ dropDownTextField: UIDropDownTextField, didSelectRowAt indexPath: IndexPath)
    {
        let aDropDownObject: UIDropDownObject = adsTypeList[indexPath.row]
        adType = aDropDownObject.title
    }
    
    func dropDownTextField(_ dropDownTextField: UIDropDownTextField, setOfItemsInDropDownMenu items: [UIDropDownObject]) -> [UIDropDownObject]
    {
        return adsTypeList
    }
}
