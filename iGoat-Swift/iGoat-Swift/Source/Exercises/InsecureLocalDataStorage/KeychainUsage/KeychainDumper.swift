
import Foundation
import SQLite3
import Security

class KeychainDumper {
    let arguments: NSMutableArray
    var keychainPath: String
    var passwordInGenp = ""
    let allKeychainData = NSMutableDictionary()

    init(simulatorPath: String) {
        arguments = NSMutableArray()
        arguments.add(kSecClassGenericPassword)
        arguments.add(kSecClassInternetPassword)
        arguments.add(kSecClassIdentity)
        arguments.add(kSecClassCertificate)
        arguments.add(kSecClassKey)
        
        keychainPath = simulatorPath
    }
 
    func getKeychainObjects(forSecClass kSecClassType: CFTypeRef?) -> [Any]? {
        var genericQuery = [AnyHashable: Any]()
        genericQuery[kSecClass] = kSecClassType
        genericQuery[kSecMatchLimit] = kSecMatchLimitAll
        genericQuery[kSecReturnAttributes] = kCFBooleanTrue
        genericQuery[kSecReturnRef] = kCFBooleanTrue
        genericQuery[kSecReturnData] = kCFBooleanTrue
        var keychainItems: AnyObject?
        let ret: OSStatus = SecItemCopyMatching(genericQuery as CFDictionary, &keychainItems)
        switch ret {
        case errSecSuccess:
            print("Keychain Read Successfully")
        case errSecItemNotFound:
            print("iGoat keychain Record Item has not found")
            keychainItems = nil
        default:
            print("keychain error code : \(ret)")
            keychainItems = nil
        }
        return keychainItems as? [Any]
    }
    
 }
