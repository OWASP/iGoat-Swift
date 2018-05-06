import UIKit

class StringAnalysisExerciseVC: UIViewController {

    @IBOutlet weak var answerTextField: UITextField!
        
    @IBAction func submit() {
        
        if answerTextField.text!.isEmpty {
            UIAlertController.showAlertWith(title: "iGoat", message: "Empty entry!!")
            return
        }
        
        let text = answerTextField.text ?? ""
        
        if (self.isValidResponse(proposedText: text)) {
            if self.isPlaintextStringTableEntry() {
                UIAlertController.showAlertWith(title: "Almost there...",
                                                message: "How can you change the string table entry to not store the plaintext answer?")
            } else {
                UIAlertController.showAlertWith(title: "Congratulations!",
                                                message: "You appear to have protected the answer against string analysis")
            }
        } else {
            UIAlertController.showAlertWith(title: "Incorrect!",
                                            message: "Look at the hints if you're having trouble analyzing the binary for the answer")
        }
    }
}


enum SAConstants {
    static let stringAnalysisExercise = "to prove it wasn’t chicken"
}

extension StringAnalysisExerciseVC {
    func retrieveStringTableEntry() -> String {
        return SAConstants.stringAnalysisExercise
    }

    func isValidResponse(proposedText: String) -> Bool {
        let stringTableEntry = retrieveStringTableEntry()
        return stringTableEntry.contains(proposedText)
    }

    func isPlaintextStringTableEntry() -> Bool {
        return false
    }
}



//Solution on cryptic encoding.
/*
enum SAConstants {
    static let stringAnalysisExercise = "HShPEQYGMQpBHR1nGAAHB6Xv+ABJJAcIFwIiAQ=="
}
 
extension StringAnalysisExerciseVC {
    
    func encrypt(_ inputString: String) -> [UInt8] {
        let key = "iGoat"
        let cipher = [UInt8](key.utf8)
        let text = [UInt8](inputString.utf8)
        var encrypted = [UInt8]()
        // encrypt bytes
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % key.length])
        }
        return encrypted
    }
    
    func decrypt(_ bytes: [UInt8]) -> String {
        let key = "iGoat"
        let cipher = [UInt8](key.utf8)
        var decrypted = [UInt8]()
        for t in bytes.enumerated() {
            decrypted.append(t.element ^ cipher[t.offset % key.length])
        }
        return String(bytes: decrypted, encoding: .utf8) ?? ""
    }

    func retrieveStringTableEntry() -> String {
        print(SAConstants.stringAnalysisExercise)
        return SAConstants.stringAnalysisExercise
    }
    
    func isValidResponse(proposedText: String) -> Bool {
        let data = Data(base64Encoded: retrieveStringTableEntry())
        let buf = [UInt8](data!)
        let stringTableEntry = decrypt(buf)
        return stringTableEntry.contains(proposedText)
    }
    
    func isPlaintextStringTableEntry() -> Bool {
        return false
    }
}


extension String {
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

*/




