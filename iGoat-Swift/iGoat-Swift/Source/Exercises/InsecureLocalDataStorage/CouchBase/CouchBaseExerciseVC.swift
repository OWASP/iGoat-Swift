
import UIKit

class CouchBaseExerciseVC: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var diseaseTextField: UITextField!
    
    let CBKeyPatientName = "CouchKeyPatientName";
    let CBKeyPatientAge = "CouchKeyPatientAge";
    let CBKeyPatientGender = "CouchKeyPatientGender";
    let CBKeyPatientDisease = "CouchKeyPatientDisease";
    
    let CBValuePatientName = "Jane Roe";
    let CBValuePatientAge = "52";
    let CBValuePatientGender = "Female";
    let CBValuePatientDisease = "Cancer";
    
    var database:CBLDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try database = CBLManager.sharedInstance().databaseNamed("couchbasedb")
        } catch {
        }

        saveData()
    }

    func saveData() {
        if UserDefaults.standard.object(forKey: "documentID") == nil {
            let properties = [CBKeyPatientName:CBValuePatientName,
                              CBKeyPatientAge : CBValuePatientAge,
                              CBKeyPatientGender : CBValuePatientGender,
                              CBKeyPatientDisease : CBValuePatientDisease]
            
            let newDocument = database?.createDocument()
            
            do {
                try newDocument?.putProperties(properties)
            } catch {
            }
            
            UserDefaults.standard.set(newDocument?.documentID, forKey: "documentID")
        }
    }
    
    @IBAction func verifyItemPressed() {
        
        let info:Dictionary<String, String> = [CBKeyPatientName: self.nameTextfield.text!,
                                               CBKeyPatientAge: self.ageTextField.text!,
                                               CBKeyPatientGender: self.genderTextField.text!,
                                               CBKeyPatientDisease: self.diseaseTextField.text!]

        let isVerified = verifyPatientInfo(info)
        UIAlertController.showAlertWith(title: "iGoat", message: isVerified ? "Success!!" :  "Failed")
    }
    
    func verifyPatientInfo(_ info:Dictionary<String, String>) -> Bool {
    
        let documentId = UserDefaults.standard.object(forKey: "documentID") as! String
        let document:CBLDocument = (database?.document(withID: documentId))!
        
        let isEqual = (document.property(forKey: CBKeyPatientName) as? String == info[CBKeyPatientName]) &&
            (document.property(forKey: CBKeyPatientAge) as? String == info[CBKeyPatientAge]) &&
            (document.property(forKey: CBKeyPatientGender) as? String == info[CBKeyPatientGender]) &&
            (document.property(forKey: CBKeyPatientDisease) as? String == info[CBKeyPatientDisease])

        return isEqual
    }
    
}
