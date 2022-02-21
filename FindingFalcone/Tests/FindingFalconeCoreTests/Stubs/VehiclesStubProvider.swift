import FindingFalconeCore

struct VehicleListStubProvider: VehicleListProvider {
    let items: [Vehicle]
    
    func getList(completion: @escaping Completion) {
        completion(.success(items))
    }
}
