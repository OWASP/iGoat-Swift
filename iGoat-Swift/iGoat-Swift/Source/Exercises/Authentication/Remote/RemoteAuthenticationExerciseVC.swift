import UIKit

enum RAConstants {
    enum EndPoints {
        static func loginUser(name: String, password: String) -> String {
            return "http://localhost:8080/igoat/token?username=\(name)&password=\(password)"
        }
    }
}

class RemoteAuthenticationExerciseVC: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func submitItemPressed() {
        if usernameTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Username Field empty!!")
            return
        } else if passwordTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Password Field empty!!")
            return
        }
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let urlString = RAConstants.EndPoints.loginUser(name: username, password: password)
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
      
        hitRequest(withURL: url)
    }
}

extension RemoteAuthenticationExerciseVC {
    func hitRequest(withURL url: URL) {
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        SVProgressHUD.show()
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let response = response as? HTTPURLResponse {
                    if let _ = response.allHeaderFields["X-Goat-Secure"] as? Bool {
                        UIAlertController.showAlertWith(title: "Congratulations!",
                                                        message: "The user's authentication credentials were protected in transit.")
                    } else {
                        UIAlertController.showAlertWith(title: "Owned",
                                                        message: "The user's authentication credentials were stolen by someone on your Wi-Fi!")
                    }
                } else {
                    UIAlertController.showAlertWith(title: "Error", message: "Operation could not be completed")
                }
            }
        })
        task.resume()
    }
}
