//
//  BinaryCookiesExerciseVC.swift
//  iGoat-Swift
//  Copyright © 2018 OWASP. All rights reserved.
//

import UIKit

fileprivate
enum BCConstants {
    static let endPoint = "http://www.github.com/OWASP/iGoat"
    
    static let sessionTokenValue = "dfr3kjsdf5jkjk420544kjkll"
    static let sessionTokenKey = "sessionKey"
    
    static let csrfTokenValue = "fkdjkjxerioxicoxci3434"
    static let csrfTokenKey = "CSRFtoken"
    
    static let userNameValue = "Doe321"
    static let userNameKey = "username"
}

extension Array where Element == HTTPCookie {
    mutating func delete(element: HTTPCookie) {
        self = self.filter() { $0 !== element }
    }
}

class BinaryCookiesExerciseVC: UIViewController {
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var sessionTxtField: UITextField!
    @IBOutlet weak var csrfTxtField: UITextField!
    
    @IBAction func verifyItemPressed() {
        let isVerified = verifyName(nameTxtField.text ?? "",
                   sessionToken: sessionTxtField.text ?? "",
                   csrfToken: csrfTxtField.text ?? "")
        let message = isVerified ? "Success!!" : "Failed"
        UIAlertController.showAlertWith(title: "iGoat", message: message)
    }
    
    
    /*
     On viewDidLoad, you can store 3 fields in binary cookies format as:
     1. session token: dfr3kjsdf5jkjk420544kjkll
     2. csrf token: fkdjkjxerioxicoxci3434
     3. username: doe321
     */
    func verifyName(_ name: String?, sessionToken: String?, csrfToken: String?) -> Bool {
        var cookieKeys = [BCConstants.userNameValue, BCConstants.csrfTokenKey, BCConstants.sessionTokenKey]
        var cookieValues = [BCConstants.userNameValue, BCConstants.csrfTokenValue, BCConstants.sessionTokenValue]
        let endPointURL = URL(string: BCConstants.endPoint)!
        var cookies = HTTPCookieStorage.shared.cookies(for: endPointURL) ?? []
        
        while cookies.count != 0 {
            var found = false
            var cap_cookie: HTTPCookie?
            for cookie in cookies {
                if let _ = cookieKeys.index(of: cookie.name) {
                    found = true
                    cap_cookie = cookie
                    break
                }
            }
            if found == false { return false }
            
            guard let cookie = cap_cookie else { continue }
            guard let index = cookieKeys.index(of: cookie.name) else {
                return false
            }
            let cookieValue = cookieValues[index]
            if cookie.value != cookieValue { return false }
            cookieKeys.remove(at: index)
            cookieValues.remove(at: index)
            cookies.delete(element: cookie)
        }
        return true
    }
    
    func captureCookie(withKey key: String, value: String) -> HTTPCookie? {
        let currentDate = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month], from: currentDate)
        components.setValue(components.month, for: .month)
        let expireDate = calendar.date(byAdding: components, to: currentDate)
        let expireInterval = expireDate?.timeIntervalSince1970
        let endPointURL = URL(string: BCConstants.endPoint)!
        let usernameProperties = [
            HTTPCookiePropertyKey.domain: endPointURL.host!,
            HTTPCookiePropertyKey.path: endPointURL.path,
            HTTPCookiePropertyKey.name: key,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.expires: expireInterval ?? 0
            ] as [HTTPCookiePropertyKey : Any]
        let httpCookie = HTTPCookie(properties: usernameProperties)
        return httpCookie
    }
    
    func saveCookies() {
        let basicInfos = [[BCConstants.userNameKey: BCConstants.userNameValue],
                              [BCConstants.csrfTokenKey: BCConstants.csrfTokenValue],
                              [BCConstants.sessionTokenKey: BCConstants.sessionTokenValue]]
        var cookies = [HTTPCookie]()
        for info in basicInfos {
            let cookie = captureCookie(withKey: info.first!.key, value: info.first!.value)
            if let cookie = cookie {
                cookies.append(cookie)
            }
        }
        let endPointURL = URL(string: BCConstants.endPoint)!
        HTTPCookieStorage.shared.setCookies(cookies, for: endPointURL, mainDocumentURL: nil)
    }

}
