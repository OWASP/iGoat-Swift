import UIKit

class MenuTableViewController: UITableViewController {
    var assets: [Asset] = [] {
        didSet {
            tableView.reloadData()
            igoatIconTapped()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.identifier)
        let aboutNib = UINib(nibName: "AboutCell", bundle: nil)
        tableView.register(aboutNib, forCellReuseIdentifier: AboutCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: - Table view data source
extension MenuTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as! AboutCell
            if let overlayButton = cell.overlayButton,
                overlayButton.allTargets.count == 0 {
                overlayButton.addTarget(self, action: #selector(igoatIconTapped),
                                        for: .touchUpInside)
            }
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = assets[indexPath.row - 1].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            igoatIconTapped()
        } else {
            loadExercise(at: indexPath.row - 1)
        }
    }

    @objc func igoatIconTapped() {
        let aboutVC: HTMLViewController = HTMLViewController.loadFromNib()
        _ = aboutVC.view
        aboutVC.contentHTMLFile = "splash.html"
        let navVC = UINavigationController(rootViewController: aboutVC)
        aboutVC.title = "About iGoat"
        sideMenuController?.embed(centerViewController: navVC)
    }
    
    func loadExercise(at index: Int) {
        let asset = assets[index]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let flowVC = storyboard.instantiateInitialViewController() as? ExerciseFlowController
            else { return }
        
        flowVC.asset = asset
        sideMenuController?.embed(centerViewController: flowVC)
    }
}
