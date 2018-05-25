
import UIKit

class KeychainExerciseVC: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secureStore(userName: "iGoat", password: "taoGi")
    }

    
    func secureStore(userName: String, password: String) {
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: "SaveUser",
                                                    account: userName,
                                                    accessGroup: nil)
            
            // Save the password for the new item.
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }

    // MARK: - Action for checking username/password
    @IBAction func loginAction(sender: UIButton) {
        // Check that text has been entered into both the username and password fields.
        guard let username = usernameTextField.text,
            let password = passwordTextField.text
             else {
                UIAlertController.showAlertWith(title: "Error", message: "Fields empty")
                return
        }
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if usernameTextField.hasText {
            let loggedIn = checkLogin(username: username, password: password)
            UIAlertController.showAlertWith(title: "iGoat", message: loggedIn ? "Success" : "Fail")
        }
        
    }
    
    func checkLogin(username: String, password: String) -> Bool {
        do {
            let passwordItem = KeychainPasswordItem(service: "SaveUser",
                                                    account: username,
                                                    accessGroup: nil)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            print("Error reading password from keychain - \(error)")
        }
        return false
    }
}
