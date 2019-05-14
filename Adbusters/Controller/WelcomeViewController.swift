import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var instructionsView: UIView!
    
    @IBOutlet var termsAndConditionsView: UIView!
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet var mask: UIView!
    
    @IBAction func closeInstructions(_ sender: Any) {
        instructionsView.isHidden = true
        defaults.set(true, forKey: "showInstructions")
    }
    
    @IBAction func closeTermsAndConditions(_ sender: Any) {
        termsAndConditionsView.isHidden = true
        defaults.set(true, forKey: "showTerms")
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
        let showTerms = defaults.bool(forKey: "showTerms")
        
        instructionsView.isHidden = showInstructions
        termsAndConditionsView.isHidden = showTerms
    }
}
