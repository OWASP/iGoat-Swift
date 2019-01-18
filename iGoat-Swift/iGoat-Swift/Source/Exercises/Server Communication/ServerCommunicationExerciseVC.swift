//
//  ServerCommunicationExerciseVC.swift
//  iGoat-Swift
//
//  Created on 6/7/18.
//  Copyright © 2018 OWASP. All rights reserved.
//

import UIKit

class ServerCommunicationExerciseVC: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var ssnField: UITextField!
    
    let serverCommunicationUserUrl = "http://localhost:8080/igoat/user"

    @IBAction func submit(_ sender: Any) {
        
        let accountInfo = ["firstName":firstNameField.text,
                           "lastName":lastNameField.text,
                           "socialSecurityNumber":ssnField.text]
        
        do {
            //resign first responder before attempting to submit data. 
            firstNameField.resignFirstResponder()
            lastNameField.resignFirstResponder()
            ssnField.resignFirstResponder()
            
            let jsonData = try JSONSerialization.data(withJSONObject: accountInfo, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: serverCommunicationUserUrl)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("close", forHTTPHeaderField: "Connection")
            request.httpBody = jsonData

            URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let sslEnabled = (response as? HTTPURLResponse)?.allHeaderFields["X-Goat-Secure"] as? String {
                    if sslEnabled.boolValue {
                        UIAlertController.showAlertWith(title: "Congratulations!", message: "The user's account info was protected in transit.")
                    } else {
                        UIAlertController.showAlertWith(title: "Owned", message: "The user's account profile info was stolen by someone on your Wi-Fi!")
                    }
                } else {
                    UIAlertController.showAlertWith(title: "Error", message: "Malformed data. There could be something wrong in your connection. See the documentation in igoat_server.rb for additional info.")
                }
                
            }).resume()
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}

//******************************************************************************
// SOLUTION
//
// The iGoat server listens on two separate ports simultaneously; 8443 (SSL)
// and 8080 (non-SSL). To secure the POST to the /igoat/user endpoint, change
// the SERVERCOMMUNICATION_USER_URL constant at the top of the file to...
//
// "https://localhost:8443/igoat/user"
//
// The URLSession class will automatically wrap the connection in an SSL
// channel and the communication between client and server will be secure.
//
// See the documentation in igoat_server.rb for additional info.
//
// Additionally, uncomment the two methods defined below to instruct the
// URLSession to ignore the fact that the iGoat server is using a
// self-signed certificate. Normally you would NOT want to do this in a
// production environment.
//******************************************************************************

