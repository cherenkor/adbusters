import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet var mask: UIView!
    
    @IBAction func closeInstructions(_ sender: Any) {
        instructionsView.isHidden = true
        defaults.set(true, forKey: "showInstructions")
    }
    
    override func viewDidLoad() {
        setCurrentUserData ()
        if isLogged {
            performSegue(withIdentifier: "goToMap", sender: nil)
        } else {
             mask.isHidden = true
            super.viewDidLoad()
            cleanCookies()
            textField.textAlignment = .natural
            currentUserId = 21
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        instructionsView.isHidden = true
        let showInstructions = defaults.bool(forKey: "showInstructions")
        instructionsView.isHidden = showInstructions
    }
}
