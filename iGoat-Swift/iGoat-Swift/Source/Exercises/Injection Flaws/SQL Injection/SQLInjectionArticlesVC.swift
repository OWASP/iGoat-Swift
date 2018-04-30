import UIKit

class SQLInjectionArticlesVC: UITableViewController {
    var articles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Articles"
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row]
        return cell
    }
}
