import Foundation

extension URL {
    var parmetersInfo: [AnyHashable: Any]? {
        let urlComponents = URLComponents(url: self as URL, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        var queryStringDictionary = [String: String]()
        for queryItem: URLQueryItem? in queryItems ?? [URLQueryItem?]() {
            if let name = queryItem?.name {
                let value = queryItem?.value != nil ? queryItem?.value : ""
                queryStringDictionary[name] = value
            }
        }
        return queryStringDictionary
    }
}
