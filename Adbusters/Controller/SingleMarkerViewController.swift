import UIKit

class SingleMarkerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var currentTypeLbl: UILabel!
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    @IBOutlet var currentComment: UITextView!
    var isImageEmpty = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        if singleMarkerAdImageArray.count == 0 {
            singleMarkerAdImageArray.append(AdImage())
            isImageEmpty = true
        }
        super.viewDidLoad()
        currentTypeLbl.text = singleMarkerType
        currentDateLbl.text = convertDate(dateStr: singleMarkerDate)
        currentComment.text = singleMarkerComment
        
    }
    
    @IBAction func goToMapTapped(_ sender: Any) {
        singleMarkerImages = [UIImage]()
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return singleMarkerAdImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleAdCollectionViewCell
        
        if isImageEmpty {
            return cell
        }
        
        if singleMarkerImages.count > 0 {
            cell.imageView.image = singleMarkerImages[indexPath.row]
        } else {
            let urlString = singleMarkerAdImageArray[indexPath.row].image
            if let url = URL(string: urlString!) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                    guard let data = data, error == nil else {
                        print("\nerror on download \(error ?? "" as! Error)")
                        return
                    }
                    DispatchQueue.main.async(execute: {
                        let currentImage = UIImage(data: data)!
                        cell.imageView.image = currentImage
                        singleMarkerImages.append(currentImage)
                    })
                }).resume()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if singleMarkerImages.count == 0 { return }
        currentAdImage = singleMarkerImages[indexPath.row]
        performSegue(withIdentifier: "goToSingleMarkerImageView", sender: nil)
    }
}
