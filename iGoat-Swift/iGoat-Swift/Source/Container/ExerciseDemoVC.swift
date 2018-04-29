

import UIKit

class ExerciseDemoVC: UIViewController {
    @IBOutlet weak var containerView: UIView!

    var exercise: Exercise?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDemoVC()
    }
}

extension ExerciseDemoVC {
    func configureDemoVC() {
        guard
            let exercise = exercise,
            let ViewController = NSClassFromString("iGoat_Swift." + exercise.viewControllerIdentifier) as? UIViewController.Type
        else { return }
        self.title = exercise.name
        let viewController = ViewController.init(nibName: exercise.viewControllerIdentifier, bundle: nil)
        let view = viewController.view
        view?.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                       options: [], metrics:nil,
                                       views: ["childView": viewController.view]).forEach { $0.isActive = true }
        NSLayoutConstraint.constraints(withVisualFormat: "|[childView]|",
                                       options: [], metrics:nil,
                                       views: ["childView": viewController.view]).forEach { $0.isActive = true }
    }
    
    @IBAction func solutionItemPressed() {
        let htmlVC = HTMLViewController(nibName: "HTMLViewController", bundle: nil)
        _ = htmlVC.view
        if let name = exercise?.name { htmlVC.title = name }
        htmlVC.contentString = exercise?.htmlSolution ?? ""
        navigationController?.pushViewController(htmlVC, animated: true)
    }
    
    @IBAction func hintItemPressed() {
        guard let hintVC = storyboard?.instantiateViewController(type: HintVC.self) else { return }
        navigationController?.pushViewController(hintVC, animated: true)
        _ = hintVC.view
        hintVC.exercise = exercise
    }
}
