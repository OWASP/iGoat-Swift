import UIKit

class RuntimeAnalysisChallengeVC: UIViewController {
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hiddenText = String(cString: do_it())
        hintLabel.text = hiddenText
    }

    @IBAction func sendItemTapped() {
        guard textField.text?.isEmpty ?? false
            else {
                UIAlertController.showAlertWith(title: "iGoat", message: "Empty entry!!")
                return
        }
        
        let secret = textField.text ?? ""
        if secret == hintLabel.text {
            UIAlertController.showAlertWith(title: "Congratulations!", message: "You found the secret!!")
            return
        }
        UIAlertController.showAlertWith(title: "Verification Failed.", message: "This is not the string you are looking for. Try again.")
    }
}
