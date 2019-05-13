import UIKit

class SingleMarkerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var currentPoliticianLbl: UILabel!
    @IBOutlet weak var currentPartyLbl: UILabel!
    
    
    @IBOutlet weak var currentTypeLbl: UILabel!
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var currentComment: UITextView!
    
    
    
    var isImageEmpty = false
    var tasks = [URLSessionDataTask]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        if singleMarkerAdImageArray.count == 0 {
            singleMarkerAdImageArray.append(AdImage())
            isImageEmpty = true
        }
        super.viewDidLoad()
        currentPartyLbl.text = singleMarkerParty
        currentPoliticianLbl.text = singleMarkerPolitician
        currentTypeLbl.text = singleMarkerType
        currentDateLbl.text = convertDate(dateStr: singleMarkerDate)
        currentComment.text = singleMarkerComment
    }
    
    @IBAction func goToMapTapped(_ sender: Any) {
        singleMarkerImages = [UIImage]()
        for task in tasks {
            task.cancel()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func markAbusive(_ sender: Any) {
    }
    
    @IBAction func blockUser(_ sender: Any) {
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
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "logo_violet"))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! SingleAdCollectionViewCell
        
        currentAdImage = currentCell.imageView.image
        performSegue(withIdentifier: "goToSingleMarkerImageView", sender: nil)
    }
}
