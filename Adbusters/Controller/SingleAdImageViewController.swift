import UIKit

class SingleAdImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = currentAdImage
    }

}
