
import UIKit

class NSUserDefaultsStorageExerciseVC: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeInDefaults()
    }

    func storeInDefaults() {
        UserDefaults.standard.set("53cr3tP", forKey: "PIN")
    }
    
    @IBAction func verifyItemPressed() {
        if textfield.text?.isEmpty == true || textfield.text == "" {
            UIAlertController.showAlertWith(title: "Error", message: "Enter details!")
        } else if
            let pin = UserDefaults.standard.object(forKey: "PIN") as? String,
            pin == textfield.text {
            textfield.text = ""
            UIAlertController.showAlertWith(title: "Success",
                                                message: "Congrats! You're on right track.")
        } else {
            UIAlertController.showAlertWith(title: "Invalid!", message: "Try harder!!")
        }
    }
}
