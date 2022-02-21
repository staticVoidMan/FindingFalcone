import Foundation
import FindingFalconeCore

/// Concrete API sourced implementation of `FindFalconeStrategy`
public class FindFalconeAPIStrategy: FindFalconeStrategy {
    private let url: URL = URL(string: APIEndpoints.findFalcone)!
    let tokenProvider: TokenProvider = TokenAPIProvider()
    
    private var token: Token? = nil {
        didSet {
            isRenewingToken = false
        }
    }
    private var isRenewingToken = false
    
    public init() {
        newSession()
    }
    
    public func newSession() {
        isRenewingToken = true
        tokenProvider.getToken { [weak self] result in
            self?.token = try? result.get()
        }
    }
    
    public func findFalcone(planets: [Planet.Name], vehicles: [Vehicle.Name], completion: @escaping Completion) {
        guard isRenewingToken == false else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.findFalcone(planets: planets, vehicles: vehicles, completion: completion)
            }
            return
        }
        
        guard let token = token else {
            completion(nil)
            return
        }

        let payload = FindFalconeRequestTO(token: token,
                                           planets: planets.map { $0.rawValue },
                                           vehicles: vehicles.map { $0.rawValue })
        let data = try! JSONEncoder().encode(payload)
        
        APIResource<FindFalconeResponseTO>(url: url, method: .post(data))
            .request { (result) in
                switch result {
                case .success(let response):
                    completion(response.planetName)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
    }
}
