import UIKit

extension UIViewController {
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
    class func topVisibleViewController(of viewController: UIViewController? = nil) -> UIViewController {
        var viewController = viewController
        if viewController == nil {
            viewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if let navigationController = viewController as? UINavigationController,
            navigationController.viewControllers.count != 0 {
            return topVisibleViewController(of:navigationController.viewControllers.last)
        }
            
        else if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topVisibleViewController(of: selectedViewController)
        }
            
        else if let presentedController = viewController?.presentedViewController {
            return topVisibleViewController(of: presentedController)
        }
        return viewController!
    }
}
