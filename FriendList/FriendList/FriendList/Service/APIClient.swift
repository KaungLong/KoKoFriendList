import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case unknown
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIPath: String {
    case userData = "man.json"
    case friendList1 = "friend1.json"
    case friendList2 = "friend2.json"
    case friendWithInvites = "friend3.json"
    case emptyFriendList = "friend4.json"
    case errorAPI = "error"
    
    var path: String {
        return self.rawValue
    }
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://dimanyen.github.io/"
    
    private init() {}
    
    func request<T: Decodable>(
        path: APIPath,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> Observable<T> {
        guard let url = URL(string: "\(baseURL)\(path.path)") else {
            return Observable.error(APIError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters, method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(APIError.requestFailed(error))
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(APIError.unknown)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.decodingFailed(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
