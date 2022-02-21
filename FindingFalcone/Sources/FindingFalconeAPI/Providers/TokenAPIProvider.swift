import Foundation

/// Concrete API sourced implementation of `TokenProvider`
///
/// Provides a session token to be provided to the API when sending the Find-Falcone request
public struct TokenAPIProvider: TokenProvider {
    let url: URL = URL(string: APIEndpoints.getToken)!
    
    public func getToken(_ completion: @escaping Completion) {
        APIResource<TokenResponseTO>(url: url, method: .post(nil))
            .request { (result) in
                switch result {
                case .success(let response):
                    completion(.success(response.token))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
}
