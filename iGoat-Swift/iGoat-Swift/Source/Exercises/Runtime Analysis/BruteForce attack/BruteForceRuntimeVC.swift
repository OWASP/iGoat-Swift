import UIKit

class BruteForceRuntimeVC: UIViewController {
    @IBOutlet weak var pinTextField: UITextField!
    
    @IBAction func verifyItemPressed() {
        if pinTextField.text?.isEmpty ?? true {
            UIAlertController.showAlertWith(title: "iGoat", message: "Empty entry!!")
            return
        }
     
        let pinText = pinTextField.text ?? ""
        
        if validatePin(pinText) {
            UIAlertController.showAlertWith(title: "Congratulations!", message: "You found the correct PIN!!!")
            return
        }
        UIAlertController.showAlertWith(title: "Verification Failed.", message: "Try again with correct PIN")
    }
    
    func validatePin(_ pin: String) -> Bool {
        // 6765
        let reference = "0252B081BDA70B478F0131B310A93CB8D79086D785FB4AE392A8C5FFC3DDC5FE"
        let data = ccSha256(data: pin.data(using: .utf8)!)
        let pinSHA256 = data.map { String(format: "%02hhx", $0) }.joined()
        return reference == pinSHA256.uppercased()
    }
    
    func ccSha256(data: Data) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return digest
    }
}
