import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(type: T.Type) -> T {
        var fullName: String = String(describing: T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = String(fullName[range.upperBound...])
        }
        return self.instantiateViewController(withIdentifier: fullName) as! T
    }
}
