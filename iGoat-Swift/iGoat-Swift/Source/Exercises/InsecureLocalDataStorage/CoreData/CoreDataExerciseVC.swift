
import UIKit
import CoreData

class CoreDataHelper {
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class CoreDataExerciseVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeDetails()
    }
    
    @IBAction func verify() {
        let user = fetchUser()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                UIAlertController.showAlertWith(title: "Error", message: "Fields empty")
                return
        }
        
        UIAlertController.showAlertWith(title: "iGoat", message:
            (user?.email == email && user?.password == password) ? "Success" : "Failed")
    }
    
    func fetchUser() -> User? {
        var user: User?
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try coreDataHelper.persistentContainer.viewContext.fetch(fetchRequest)
            print(users)
            user = users.first
        } catch {
            print("something happened")
        }
        return user
    }
    
    func storeDetails() {
        var user: User?
        user = fetchUser()
        guard user == nil else { return }
        
        let context = coreDataHelper.persistentContainer.viewContext
        user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        if let user = user {
            user.email = "john@test.com"
            user.password = "coredbpassword"
            coreDataHelper.saveContext()
        }
    }
}
