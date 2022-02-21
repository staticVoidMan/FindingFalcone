import Foundation
import FindingFalconeCore

/// Concrete API sourced implementation of `VehicleListProvider`
public struct VehicleListAPIProvider: VehicleListProvider {
    let url: URL = URL(string: APIEndpoints.getVehicles)!
    
    public init() {}
    
    public func getList(completion: @escaping Completion) {
        APIResource<[Vehicle]>(url: url, method: .get).request(completion)
    }
}
