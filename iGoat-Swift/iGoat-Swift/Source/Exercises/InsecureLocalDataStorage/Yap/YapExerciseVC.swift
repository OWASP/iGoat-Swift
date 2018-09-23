
import UIKit

class YapExerciseVC: UIViewController {
    
    static let YapValueEmail = "JohnDoe@yap.com"
    static let YapValuePassword = "TheUnknown"
    static let YapKeyEmail = "YapKeyEmail"
    static let YapKeyPassword = "YapKeyPassword"

    static let YapCollection = "iGoat"
    static let YapDBName = "YapDatabase.sqlite"
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveData()
    }

    func saveData() {
        let database = YapDatabase(path: databasePath)
        let connection = database.newConnection()
        connection.readWrite { (transaction) in
            transaction.setObject(YapExerciseVC.YapValueEmail, forKey: YapExerciseVC.YapKeyEmail, inCollection: YapExerciseVC.YapCollection)
            transaction.setObject(YapExerciseVC.YapValuePassword, forKey: YapExerciseVC.YapKeyPassword, inCollection: YapExerciseVC.YapCollection)
        }
    }
    
    @IBAction func verifyItemPressed() {
        let isVerified = verifyName(usernameTextField.text!, enteredPassword: passwordTextField.text!)
        let message = isVerified ? "Success!!" : "Failed"
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    var databasePath:String! {
        var baseURL:URL!
        do {
            baseURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
        }
        return baseURL.appendingPathComponent(YapExerciseVC.YapDBName, isDirectory: false).path
    }
    
    func verifyName(_ enteredUserName:String, enteredPassword:String) -> Bool {
        
        let database = YapDatabase(path: databasePath)
        let connection = database.newConnection()
        var isVerified = false
        
        connection.read { (transaction) in
            let email = transaction.object(forKey: YapExerciseVC.YapKeyEmail, inCollection: YapExerciseVC.YapCollection) as? String
            let password = transaction.object(forKey: YapExerciseVC.YapKeyPassword, inCollection: YapExerciseVC.YapCollection) as? String
            if email == nil || password == nil {
                isVerified = false
            }
            isVerified = email == enteredUserName && password == enteredPassword
        }

        return isVerified
    }
}
