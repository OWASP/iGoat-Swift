import UIKit
import SQLite3

class SQLInjectionExerciseVC: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func search() {
        let dbPath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent("articles.sqlite").absoluteString
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            UIAlertController.showAlertWith(title: "Snap!", message: "Error opening articles database.")
            return
        }
        
        var searchStr = "%"
        if !(searchField.text?.isEmpty ?? true) {
             searchStr = "%" + "\(searchField.text!)" + "%"
        }
        
        let query = "SELECT title FROM article WHERE title LIKE '\(searchStr)' AND premium=0"
        var stmt: OpaquePointer?
        sqlite3_prepare_v2(db, query, -1, &stmt, nil)
        var articleTitles = [String]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let title = String(cString: sqlite3_column_text(stmt, 0))
            articleTitles.append(title)
        }
        sqlite3_finalize(stmt)
        sqlite3_close(db)
        
        let sqlInjectionArticlesVC = SQLInjectionArticlesVC(nibName: "SQLInjectionArticlesVC", bundle: nil)
        sqlInjectionArticlesVC.articles = articleTitles
        navigationController?.pushViewController(sqlInjectionArticlesVC, animated: true)
    }
}
