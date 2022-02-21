import FindingFalconeCore

struct PlanetListStubProvider: PlanetListProvider {
    let items: [Planet]
    
    func getList(completion: @escaping Completion) {
        completion(.success(items))
    }
}
