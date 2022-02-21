import Foundation
import FindingFalconeCore

/// Concrete API sourced implementation of `PlanetListProvider`
public struct PlanetListAPIProvider: PlanetListProvider {
    let url: URL = URL(string: APIEndpoints.getPlanets)!
    
    public init() {}
    
    public func getList(completion: @escaping Completion) {
        APIResource<[Planet]>(url: url, method: .get).request(completion)
    }
}
