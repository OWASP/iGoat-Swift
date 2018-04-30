import UIKit

class BinaryPatchingVC: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginItemPressed() {
        if passwordTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Password Field empty!!")
        }
        
        let password = passwordTextField.text!
        if password == "root" {
            UIAlertController.showAlertWith(title: "Incorrect Password", message: "Enter the correct password")
            return
        }
        UIAlertController.showAlertWith(title: "iGoat", message: "Congratulations")
    }
}
