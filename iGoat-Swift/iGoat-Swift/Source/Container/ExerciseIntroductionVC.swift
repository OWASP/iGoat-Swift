

import UIKit
import WebKit

class ExerciseIntroductionVC: HTMLViewController {
    var exercise: Exercise? {
        didSet {
            guard let exercise = exercise else { return }
            contentString = exercise.htmlDescription
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start",
                                                            style: .plain, target: self,
                                                            action: #selector(startExerciseItemTapped))
        navigationItem.title = "Introduction"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
                                                           target: nil, action: nil)
    }
}

extension ExerciseIntroductionVC {
    @objc func startExerciseItemTapped() {
        guard let demoVC = storyboard?.instantiateViewController(type: ExerciseDemoVC.self) else { return }
        demoVC.exercise = exercise
        navigationController?.pushViewController(demoVC, animated: true)
    }
}
