import Foundation

struct Exercise {
    enum Key: String {
        case name
        case description
        case hints
        case viewControllerIdentifier = "initialViewController"
        case creditsFile
        case solution
    }
    
    let creditsFile: String?
    let description: String?
    let hints: [String]?
    let viewControllerIdentifier: String
    let name: String?
    let solution: String?
    
    init(exerciseInfo: [String: Any]) {
        name = exerciseInfo[Key.name.rawValue] as? String
        description = exerciseInfo[Key.description.rawValue] as? String
        hints = exerciseInfo[Key.hints.rawValue] as? [String]
        guard let identifier = exerciseInfo[Key.viewControllerIdentifier.rawValue] as? String
        else { fatalError("Please Provide ViewController") }
        viewControllerIdentifier = identifier
        creditsFile = exerciseInfo[Key.creditsFile.rawValue] as? String
        solution = exerciseInfo[Key.solution.rawValue] as? String
    }

    var htmlDescription: String {
        let paraRegex = "\n *\n"
        let desc = description?.replacingOccurrences(of: paraRegex, with: "<br/><br/>",
                                                     options: [.regularExpression, .caseInsensitive])
        let htmlDesc =
 """
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
 <html>
 <head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta name="viewport" content="width=device-width,initial-scale=1">
 <link rel="stylesheet" href="stylesheet.css" type="text/css" media="all" />
 </head>
 <body>
 <h1>\(name ?? "")</h1>
 <h2>Getting Started</h2>
 <p>\(desc ?? "")</p>
 </body>
 </html>
 """
    return htmlDesc
    }
    
    var htmlSolution: String {
        let paraRegex = "\n *\n"
        var desc = description?.replacingOccurrences(of: paraRegex, with: "<br/><br/>",
                                                     options: [.regularExpression, .caseInsensitive])
       desc =
        """
        <hr>\(name ?? "")</hr>
        \(desc ?? "")
        """
        desc =  htmlTemplate(with: desc ?? "")
        return desc ?? ""
    }
}

func htmlTemplate(with body:String) -> String {
    return
"""
<html>
    <head>
        <link href="igoat.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
    \(body)
    </body>
</html>
"""
}


