
import UIKit

enum KSSConstants {
    enum EndPoints {
        static let cryptoKey = "http://localhost:8081/cryptoKey.php"
    }
    static let secretMessage = "SecretPass"
}

class KeyStorageServerSideVC: UIViewController {
    var encryptionKey = ""
    
    @IBOutlet weak var encryptedMessageLabel:UILabel!
    @IBOutlet weak var encryptionTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchKeyFromServer()
    }
    
    func fetchKeyFromServer() {
        let cryptoKeyEndpoint = KSSConstants.EndPoints.cryptoKey
        guard let url = URL(string: cryptoKeyEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = "token=key".data(using: .utf8)
        urlRequest.httpMethod = "POST"
        let headers =  ["content-type": "application/x-www-form-urlencoded",
            "accept": "text/html,application/xhtml+xml,application/xml"]
        urlRequest.allHTTPHeaderFields = headers
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        SVProgressHUD.show()
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                SVProgressHUD.dismiss()
                if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                    let message = String(data: data, encoding: .utf8)
                    weakSelf.encrypt(usingResponseString: message)
                } else {
                    UIAlertController.showAlertWith(title: "Error", message: "Operation could not be completed")
                }
            }
        })
        task.resume()
    }
    
    func encrypt(usingResponseString responseString: String?) {
        encryptionKey = key(fromResponseString: responseString) ?? ""
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let encryptedData: Data? = KSSConstants.secretMessage.data(using: .utf8)?.aes(operation: kCCEncrypt, keyData: (self?.encryptionKey.data(using: .utf8)!)!)
            var encryptedString = ""
            if let aData = encryptedData {
                encryptedString = String(data: aData, encoding: .ascii) ?? ""
            }
            weakSelf.encryptedMessageLabel.text = encryptedString
        }
    }
    
    func key(fromResponseString responseString: String?) -> String? {
        let searchFromRange: NSRange? = (responseString as NSString?)?.range(of: "<td>key</td><td>")
        let searchToRange: NSRange? = (responseString as NSString?)?.range(of: "</td></tr></table>")
        let substring = (responseString as NSString?)?.substring(with: NSRange(location: Int((searchFromRange?.location ?? 0) + (searchFromRange?.length ?? 0)), length: Int((searchToRange?.location ?? 0) - (searchFromRange?.location ?? 0) - (searchFromRange?.length ?? 0))))
        return substring
    }
    
    @IBAction func verifyItemPressed(_ sender: Any) {
        var message = "Try Harder!!.."
        if (encryptionTextField.text == encryptionKey) {
            message = "Success!!"
        }
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
}
