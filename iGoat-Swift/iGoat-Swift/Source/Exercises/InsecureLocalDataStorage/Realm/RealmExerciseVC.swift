
import UIKit

class RCreditInfo: RLMObject {
    @objc dynamic var name:String?
    @objc dynamic var cardNumber:String?
    @objc dynamic var cvv:String?
}

class RealmExerciseVC: UIViewController {
    
    @IBOutlet weak var creditNameTextField: UITextField!
    @IBOutlet weak var creditNumberTextField: UITextField!
    @IBOutlet weak var creditCVVTextField: UITextField!
    
    let RealmCardName = "John Doe";
    let RealmCardNumber = "4444 5555 8888 1111";
    let RealmCardCVV = "911";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try saveData()
        } catch {
            print("Error writing data")
        }
    }

    func saveData() throws {
        if RCreditInfo.allObjects().count == 0 {
            let realm = RLMRealm.default()
            let creditInfo = RCreditInfo()
            creditInfo.name = RealmCardName
            creditInfo.cardNumber = RealmCardNumber
            creditInfo.cvv = RealmCardCVV
            realm.beginWriteTransaction()
            realm.add(creditInfo)
            try realm.commitWriteTransactionWithoutNotifying([])
        }
        
    }
    
    @IBAction func verifyItemPressed() {
        let isVerified = verifyName(name: creditNameTextField.text!, number: creditNumberTextField.text!, cvv: creditCVVTextField.text!)
        let message = isVerified ? "Success" : "Failed"
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    func verifyName(name:String, number:String, cvv:String) -> Bool {

        guard let creditInfo = RCreditInfo.allObjects().firstObject() as? RCreditInfo else {
            return false
        }
        
        return name == creditInfo.name &&
        number.replacingOccurrences(of: " ", with: "") == creditInfo.cardNumber?.replacingOccurrences(of: " ", with: "") &&
        cvv == creditInfo.cvv
    }
}
