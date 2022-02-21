import FindingFalconeCore

struct FindFalconeStubStrategy: FindFalconeStrategy {
    var hidingPlanet: Planet.Name? = nil
    
    func newSession() {}
    
    func findFalcone(planets: [Planet.Name], vehicles: [Vehicle.Name], completion: @escaping Completion) {
        completion(hidingPlanet)
    }
}
