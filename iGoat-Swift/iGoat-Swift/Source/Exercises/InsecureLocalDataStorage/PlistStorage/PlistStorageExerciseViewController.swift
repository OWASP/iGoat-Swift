
import UIKit

class PlistStorageExerciseViewController: UIViewController {
    
    
    @IBOutlet weak var txt_user: UITextField!
    @IBOutlet weak var txt_pwd: UITextField!
    
    let plistPath = NSHomeDirectory() + "/Documents/Credentials.plist"
    let bundlePath = Bundle.main.resourcePath!.appending("/Credentials.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Plist Storage";
        storeInPlist()
    }

    func storeInPlist() {
        do {
            try FileManager.default.copyItem(atPath: bundlePath, toPath: plistPath)
        } catch {}
    }
    
    @IBAction func login(){
        
        if self.txt_user.text!.isEmpty || self.txt_pwd.text!.isEmpty {
            UIAlertController.showAlertWith(title: "Error", message: "Username and Password must not be blank")
        }
        else {
            let username = txt_user.text
            let password = txt_pwd.text
            let myDict = NSDictionary(contentsOfFile: plistPath) as! Dictionary<String, String>
            if username == myDict["User"] && password == myDict["Password"] {                
                txt_user.text = ""
                txt_pwd.text = ""
                UIAlertController.showAlertWith(title: "Success", message: "Congrats! You're on right track.")
            }
            else{
                UIAlertController.showAlertWith(title: "Invalid!", message: "Try little bit.")
            }
        }
    }
}
