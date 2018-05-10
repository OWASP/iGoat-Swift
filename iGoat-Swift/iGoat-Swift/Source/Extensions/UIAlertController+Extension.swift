import UIKit

extension UIAlertController {
    @discardableResult func cancel(_ action: String? = "Dismiss", onCancel: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        self.addAction(UIAlertAction(title: action, style: .cancel, handler: { alert in
            onCancel?(alert)
        }))
        return self
    }
    
    @discardableResult func destructive(_ action: String, onDestruct: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        self.addAction(UIAlertAction(title: action, style: .destructive, handler: { action in
            onDestruct(action)
        }))
        return self
    }
    
    func showAlert(with completion: (() -> Void)? = nil) {
        let topViewController = UIViewController.topVisibleViewController()
        topViewController.present(self, animated: true, completion: completion)
    }
    
    @discardableResult class func showAlertWith(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.cancel()
        alertController.showAlert()
        return alertController
    }
}
