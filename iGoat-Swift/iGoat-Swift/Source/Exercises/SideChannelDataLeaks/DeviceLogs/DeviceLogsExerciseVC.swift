import UIKit

class DeviceLogsExerciseVC: UIViewController {
    @IBOutlet weak var ccNoTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!

    @IBAction func submitItemPressed() {
        NSLog("ccNo: %@", ccNoTextField.text ?? "")
        NSLog("cvvNo: %@", cvvTextField.text ?? "")
        NSLog("pinNo: %@", pinTextField.text ?? "")
        UIAlertController.showAlertWith(title: "Success",
                                        message: "Data Submitted Successfully")
    }
}
