
import UIKit

class KeystrokeLoggingExerciseVC: UIViewController {
    @IBAction func sendItemPressed() {
        UIAlertController.showAlertWith(title: "Message",
                                        message: "Message Sent Successfully")
    }
}
