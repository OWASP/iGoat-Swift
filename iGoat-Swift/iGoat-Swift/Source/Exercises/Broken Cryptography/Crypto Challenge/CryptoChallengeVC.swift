import UIKit

enum CryptoConstants {
    enum Code {
        static let cardDigitRev = "1634"
        static let cardCVVRev = "926"
    }
    enum Message {
        static let success = "You bought iPhone in ZERO"
        static let failure = "Fail! You didn't purchase iPhone for $0"
    }
}

class CryptoChallengeVC: UIViewController {
    @IBAction func buyItemPressed() {
        let postInfo = ["msg": "iPhone%7Cbuy%7C1000",
            "checksum": "014a347fa0f1cac1baaaf1618481b22a1efeedf88fd1f294b2d69f72a45e6caa"]
        var postArray = [String]()
        postInfo.keys.forEach { key in postArray.append("\(key)=\(String(describing: postInfo[key]))") }
        let postStr = postArray.reduce("") { $0 + "&" + $1 }
        let postData = postStr.data(using: .utf8)
        
        let url = URL(string: "http://localhost:8081/checkout/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postData
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        SVProgressHUD.show()
        let task = session.dataTask(with: urlRequest, completionHandler: {[weak self] (data, response, error) in
            SVProgressHUD.dismiss()
            guard let weakSelf = self else { return }
            if let error = error {
                weakSelf.failedWithError(error: error)
            } else if let data = data {
                let message = String(data: data, encoding: .utf8)
                let success = weakSelf.isSuccessfulResponseString(message)
                weakSelf.showMessage(fromResponseString: message ?? "", isSuccessful: success)
            }
        })
        task.resume()
    }
}

extension CryptoChallengeVC {
    func isSuccessfulResponseString(_ responseString: String?) -> Bool {
        if Int((responseString as NSString?)?.range(of: CryptoConstants.Message.failure).location ?? 0) != NSNotFound {
            return false
        } else if Int((responseString as NSString?)?.range(of: CryptoConstants.Message.success).location ?? 0) != NSNotFound {
            return true
        } else {
            return false
        }
    }
    
    func showMessage(fromResponseString responseString: String, isSuccessful success: Bool) {
        var message = ""
        if success {
            let responseStr = responseString as NSString
            let prefixRange = responseStr.range(of: "dollar!")
            var flagString = responseStr.substring(from: (prefixRange.location ) + (prefixRange.length ))
            flagString = ((flagString as NSString).substring(to: ((flagString as NSString?)?.range(of: "}}  \n").location)!))
            message = flagString
        } else {
            message = CryptoConstants.Message.failure
        }
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    func failedWithError(error: Error) {
        let message = error.localizedDescription
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
}




