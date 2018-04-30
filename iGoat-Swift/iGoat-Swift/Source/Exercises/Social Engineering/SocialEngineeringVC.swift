import UIKit
import LocalAuthentication

class SocialEngineeringVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
 
    func addShowHideButton() {
        let hideShowSize = CGSize(width: 32, height: 32)
        let hideShowButton = UIButton(frame: CGRect(x: 0, y: 0, width: hideShowSize.width, height: passwordTxtField.frame.size.height))
        hideShowButton.setImage(UIImage(named: "hide"), for: .normal)
        passwordTxtField.rightView = hideShowButton
        passwordTxtField.rightViewMode = .always
        hideShowButton.addTarget(self, action: #selector(hideShow), for: .touchUpInside)
    }
    
    @IBAction func hideShow() {
        let hideShow = passwordTxtField.rightView as? UIButton
        if !passwordTxtField.isSecureTextEntry {
            passwordTxtField.isSecureTextEntry = true
            hideShow?.setImage(UIImage(named: "show"), for: .normal)
        } else {
            passwordTxtField.isSecureTextEntry = false
            hideShow?.setImage(UIImage(named: "hide"), for: .normal)
        }
        passwordTxtField.becomeFirstResponder()
    }
    
    @IBAction func loginItemPressed() {
        let name = nameTextField.text ?? ""
        let password = passwordTxtField.text ?? ""
        let isVerified = verifyUser(name: name, password: password)
        let message = (isVerified) ? "You have successfully logged In!!!" : "Authentication Failed!!"
        show(message: message)
    }
    
    @IBAction func authenticateViaTouchID() {
        let authenticationContext = LAContext()
        var error:NSError?
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            show(message: "No Biometric Sensor Has Been Detected. This device does not support Touch Id.")
            return
        }
        
        authenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Only device owner is allowed", reply: { [weak self] (success, error) -> Void in
            guard let weakSelf = self else { return }
            if success {
                print("Fingerprint recognized. You are a device owner!")
            } else {
                if let errorObj = error {
                    weakSelf.show(message: "Error took place. \(errorObj.localizedDescription)")
                }
            }
        })
    }
    
    func show(message: String) {
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    func verifyUser(name: String, password: String) -> Bool {
        guard
            let credentialsPath = Bundle.main.path(forResource: "Credentials", ofType: "plist"),
            let credentialsInfo = NSDictionary(contentsOfFile: credentialsPath)
        else { return false }
        
        let validUserName = credentialsInfo["User"] as? String
        let validPassword = credentialsInfo["Password"] as? String
        return ((name == validUserName) && (password == validPassword)) ? true : false
    }
}
