import UIKit

class MemoryManagementVC: UIViewController {
    @IBOutlet weak var cardNoTextField: UITextField!
    @IBOutlet weak var cardCCVTextField: UITextField!
    
    var cardNumberString: String = ""
    
    @IBAction func payItemPressed() {
        if cardNoTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Enter card number")
            return
        }
        if cardCCVTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Enter cvv number")
            return
        }
        self.cardNumberString = self.cardNoTextField.text ?? ""
        UIAlertController.showAlertWith(title: "iGoat", message: "Thanks for purchase!! Do you think card details are safe. Check out memory :)")
    }

}
