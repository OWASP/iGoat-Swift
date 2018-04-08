import UIKit

extension UIView {
    @objc open class func loadFromNib() -> Self {
        /// Helper required for returning Self while still casting to subclass
        func loadFromNibHelper<T : UIView>() -> T {
            let nib = self.nibBundle.loadNibNamed(self.nibName, owner: self, options: nil)
            return nib!.first as! T
        }
        return loadFromNibHelper()
    }
    
    /// Nib Name for the cell
    open class var nibName: String {
        return "\(self.self)"
    }
    
    /// NSBundle to fetch the nib resource from
    open class var nibBundle: Bundle {
        return Bundle(for: self.self)
    }
}
