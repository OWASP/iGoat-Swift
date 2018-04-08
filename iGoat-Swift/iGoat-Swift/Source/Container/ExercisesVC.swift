
import UIKit

class ExercisesVC: UITableViewController {
    // MARK: - Table view data source
    var asset: Asset? {
        let navVC = navigationController as! ExerciseFlowController
        return navVC.asset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        title = asset?.title
        navigationItem.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.identifier)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Table view data source
extension ExercisesVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asset?.exercises.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = asset?.exercises[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadExerciseIntroduction(at: indexPath.row)
    }
    
    func loadExerciseIntroduction(at index: Int) {
        guard let introVC = storyboard?.instantiateViewController(withIdentifier: "ExerciseIntroductionVC") as? ExerciseIntroductionVC
            else { return }
        navigationController?.pushViewController(introVC, animated: true)
        _ = introVC.view
        introVC.exercise =  asset?.exercises[index]
    }
}
