
import UIKit

class ExerciseFlowController: UINavigationController {
    var asset: Asset? {
        didSet {
            title = asset?.title
            navigationItem.title = title
        }
    }
}
