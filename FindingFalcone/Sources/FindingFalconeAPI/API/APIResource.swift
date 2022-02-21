import Foundation

struct APIResource<T: Decodable> {
    typealias CompletionResult = Result<T,Error>
    typealias Completion = (CompletionResult)->Void
    
    public enum MethodType {
        case get
        case post(_ data: Data?)
        
        var name: String {
            switch self {
            case .get : return "GET"
            case .post: return "POST"
            }
        }
        
        var data: Data? {
            switch self {
            case .get            : return nil
            case .post(let data) : return data
            }
        }
    }
    
    let url: URL
    let method: MethodType
    
    func request(_ completion: @escaping Completion) {
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.httpBody = method.data
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession
            .shared
            .dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        completion(.failure(APIResourceError.decodingFailedError(error: error)))
                    }
                }
                else {
                    completion(.failure(APIResourceError.nilDataError(error: error)))
                }
            }
            .resume()
    }
}
