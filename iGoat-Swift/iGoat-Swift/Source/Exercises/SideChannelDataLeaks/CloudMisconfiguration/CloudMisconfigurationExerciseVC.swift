import UIKit

enum CMConstants {
    static let cardDigitRev = "1634"
    static let cardCVVRev = "926"
}

class CloudMisconfigurationExerciseVC: UIViewController {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cvvTxtField: UITextField!
    @IBOutlet weak var cardNoTxtField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCardImage()
    }

    func fetchCardImage() {
        let todoEndpoint = "http://s3.us-east-2.amazonaws.com/igoat774396510/catty.gif"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        SVProgressHUD.show()
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                SVProgressHUD.dismiss()
                if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                    let image = UIImage.animatedImage(withAnimatedGIFData: data)
                    self?.cardImageView.image = image
                } else {
                    UIAlertController.showAlertWith(title: "Error", message: "Operation could not be completed")
                }
            }
        })
        task.resume()
    }

    @IBAction func verifyItemPressed() {
        if cardNoTxtField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "Error", message: "Enter card details")
            return
        }
        if cvvTxtField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "Error", message: "Enter CVV details")
            return
        }
        
        let cardNo = String(describing: cardNoTxtField.text?.reversed())
        let cvvNo = String(describing: cvvTxtField.text?.reversed())
        if cardNo == CMConstants.cardDigitRev, cvvNo == CMConstants.cardCVVRev {
            UIAlertController.showAlertWith(title: "iGoat", message: "Verified!!")
            return
        }
        UIAlertController.showAlertWith(title: "iGoat", message: "Verified!!")
    }
}

extension UIViewController {
    @IBAction func textFieldReturn(sender: UITextField) {
        sender.resignFirstResponder()
    }
}
