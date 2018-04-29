import UIKit

/*
enum SAConstants {
    static let stringAnalysisExercise = "secret plaintext riddle answer: To prove it was not chicken";
}
*/
 
class StringAnalysisExerciseVC: UIViewController {

    @IBOutlet weak var answerTextField: UITextField!
    
    @IBAction func submit() {
        guard answerTextField.text?.isEmpty ?? false
            else {
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

extension StringAnalysisExerciseVC {
    func retrieveStringTableEntry() -> String {
        return "" //SAConstants.stringAnalysisExercise
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
    static let stringAnalysisExercise = "EhEKNQoVVBsuCwUYDGcfDRUAKRsEDB1nDg8HHiIdW1Q9KE8RBgYxCkEdHWcYAAcHYBtBFwEuDAoRBw=="
 }
 
extension StringAnalysisExerciseVC {
    
    func encrypt(_ inputString: String) -> [UInt8] {
        let key = "iGoat"
        let cipher = [UInt8](key.utf8)
        let text = [UInt8](inputString.utf8)
        var encrypted = [UInt8]()
        // encrypt bytes
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset])
        }
        return encrypted
    }
    
    func decrypt(_ bytes: [UInt8]) -> String {
        let key = "iGoat"
        let cipher = [UInt8](key.utf8)
        var decrypted = [UInt8]()
        for t in bytes.enumerated() {
            decrypted.append(t.element ^ cipher[t.offset])
        }
        return String(bytes: decrypted, encoding: .utf8) ?? ""
    }

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



