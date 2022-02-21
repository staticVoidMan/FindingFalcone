import FindingFalconeCore

class FindFalconeStubStrategy: FindFalconeStrategy {
    private var responses: [Planet.Name]
    
    public init(responses: [Planet.Name]) {
        self.responses = responses
    }
    
    public func newSession() {
        responses.removeFirst()
    }
    
    public func findFalcone(planets: [Planet.Name], vehicles: [Vehicle.Name], completion: @escaping Completion) {
        let planet = responses.first!
        completion(planets.contains(planet) ? planet : nil)
    }
}
