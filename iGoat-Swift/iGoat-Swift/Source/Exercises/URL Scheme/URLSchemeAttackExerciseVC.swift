
import UIKit

class URLSchemeAttackExerciseVC: UIViewController {
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var messageTxtField: UITextField!

    @IBAction func sendMessageItemPressed() {
        let mobileNoText = mobileNumberTxtField.text ?? ""
        let messageText = messageTxtField.text ?? ""
        
        let urlSchemeText = "iGoat://?contactNumber=\(mobileNoText)&message=\(messageText)"
        let urlString = urlSchemeText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let app = UIApplication.shared
        if let urlString = urlString,
            let url = URL(string: urlString),
            app.canOpenURL(url) == true
        {
            if #available(iOS 10.0, *) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                app.openURL(url)
            }
        }
    }
}
