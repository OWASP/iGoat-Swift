
import UIKit
import CouchbaseLiteSwift

class CouchBaseExerciseVC: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var diseaseTextField: UITextField!
    
    var database: Database?

    override func viewDidLoad() {
        super.viewDidLoad()
        database = try? Database(name: "couchbasedb")
        saveData()
    }

    func saveData() {
        if UserDefaults.standard.object(forKey: "documentID") == nil {
            let document = MutableDocument(id: UserRecord.demoID)
            document.setString(UserRecord.demoUser.name, forKey: UserRecord.CBKeys.name.rawValue)
            document.setString(UserRecord.demoUser.age, forKey: UserRecord.CBKeys.age.rawValue)
            document.setString(UserRecord.demoUser.gender, forKey: UserRecord.CBKeys.gender.rawValue)
            document.setString(UserRecord.demoUser.disease, forKey: UserRecord.CBKeys.disease.rawValue)
            try? database?.saveDocument(document)
            UserDefaults.standard.set(UserRecord.demoID, forKey: "documentID")
        }
    }
    
    @IBAction func verifyItemPressed() {
        let record = UserRecord(name: nameTextfield.text!,
                                age: ageTextField.text!,
                                gender: genderTextField.text!,
                                disease: diseaseTextField.text!)
        
        let isVerified = verifyPatientInfo(record)
        UIAlertController.showAlertWith(title: "iGoat", message: isVerified ? "Success!!" :  "Failed")
    }
    
    func verifyPatientInfo(_ info: UserRecord) -> Bool {
        let documentId = UserDefaults.standard.object(forKey: "documentID") as! String
        if let document = database?.document(withID: documentId) {
            var stored = UserRecord()
            stored.age  =  document.string(forKey: UserRecord.CBKeys.age.rawValue)
            stored.gender = document.string(forKey:UserRecord.CBKeys.gender.rawValue)
            stored.name =  document.string(forKey: UserRecord.CBKeys.name.rawValue)
            stored.disease = document.string(forKey:UserRecord.CBKeys.disease.rawValue)
            return stored == info
        }
        return false
    }

    deinit {
        try? database?.close()
    }
}

let kUserRecordDocumentType = "user"
struct UserRecord : CustomStringConvertible, Equatable {
    var name:String?
    var age:String?
    var gender :String?
    var disease: String?
    
    var description: String {
        return "name = \(String(describing: name)), email = \(String(describing: age))"
    }

    enum CBKeys: String {
        case name
        case age
        case gender
        case disease
    }
}

extension UserRecord {
    static let demoUser = UserRecord(name: "Jane Roe", age: "52", gender: "Female", disease: "Cancer")
    static let demoID = "Jane Roe Doc"
}
