import UIKit
import SQLite3

let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class RandomKeyGenerationExerciseVC: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var credentialStorageSwitch: UISwitch!
    @IBOutlet weak var secretKeyField: UITextField!
    
    @IBAction func verifyItemPressed(_ sender: Any) {
        let encryptionKeyStr = UIDevice.current.identifierForVendor?.uuidString
        let message = (encryptionKeyStr == secretKeyField.text) ? "Success!!" : "Try Harder!!"
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    @IBAction func submit(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        if credentialStorageSwitch.isOn {
            storeCredentials(forUsername: username, withPassword: password)
        }
        usernameField.text = ""
        passwordField.text = ""
    }
    
    func storeCredentials(forUsername username: String?, withPassword password: String?) {
        // Write the credentials to a SQLite database.
        var credentialsDB: OpaquePointer?
        let path = pathDocumentDirectory(fileName: "credentials.sqlite")
        if sqlite3_open(path, &credentialsDB) == SQLITE_OK {
            var compiledStmt: OpaquePointer?
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
            if let aVendor = UIDevice.current.identifierForVendor {
                print("encryption key is \(aVendor)")
            }
            let encrptStmt = "PRAGMA key = '\(deviceID ?? "")'"
            sqlite3_exec(credentialsDB, encrptStmt, nil, nil, nil)
            // Create the table if it doesn't exist.
            let createStmt = "CREATE TABLE IF NOT EXISTS creds (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT);"
            
            
            sqlite3_exec(credentialsDB, createStmt, nil, nil, nil)
            // Check to see if the user exists; update if yes, add if no.
            let queryStmt = "SELECT id FROM creds WHERE username=?"
            var userID: Int = -1
            if sqlite3_prepare_v2(credentialsDB, queryStmt, -1, &compiledStmt, nil) == SQLITE_OK {
                sqlite3_bind_text(compiledStmt, 1, username, -1, SQLITE_TRANSIENT)
                while sqlite3_step(compiledStmt) == SQLITE_ROW {
                    userID = Int(sqlite3_column_int(compiledStmt, 0))
                }
                sqlite3_finalize(compiledStmt)
            }
            
            var addUpdateStmt = ""
            if userID >= 0 {
                addUpdateStmt = "UPDATE creds SET username=?, password=? WHERE id=?"
            } else {
                addUpdateStmt = "INSERT INTO creds(username, password) VALUES(?, ?)"
            }
            
            if sqlite3_prepare_v2(credentialsDB, addUpdateStmt, -1, &compiledStmt, nil) == SQLITE_OK {
                sqlite3_bind_text(compiledStmt, 1, username, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(compiledStmt, 2, password, -1, SQLITE_TRANSIENT)
                if userID >= 0 {
                    sqlite3_bind_int(compiledStmt, 3, Int32(userID))
                }
                if sqlite3_step(compiledStmt) != SQLITE_DONE {
                    print("Error storing credentials in SQLite database.")
                }
            }
            // Clean things up.
            if (compiledStmt != nil) && (credentialsDB != nil) {
                let compiledStmtStatusCode: Int = Int(sqlite3_finalize(compiledStmt))
                let credentialStmtStatusCode: Int = Int(sqlite3_close(credentialsDB))
                if compiledStmtStatusCode != SQLITE_OK {
                    print("Error finalizing SQLite compiled statement.")
                } else if credentialStmtStatusCode != SQLITE_OK {
                    print("Error closing SQLite database.") }
            }
        }
    }
}
