import UIKit

class BackgroundingExerciseVC: UIViewController {
    @IBAction func submitItemPressed() {
        UIAlertController.showAlertWith(title: "Success",
                                        message: "Data Submitted Successfully")
    }
}
