import FindingFalconeCore

struct FindFalconeStubProvider: FindFalconeProvider {
    let planets: [Planet]
    let vehicles: [Vehicle]
    
    var hidingPlanet: Planet.Name? {
        get { findStrategy.hidingPlanet }
        set { findStrategy.hidingPlanet = newValue }
    }
    
    var findStrategy: FindFalconeStubStrategy
    
    init(planets: [Planet] = [], vehicles: [Vehicle] = [], answer hidingPlanet: Planet.Name? = nil) {
        self.planets = planets
        self.vehicles = vehicles
        self.findStrategy = FindFalconeStubStrategy(hidingPlanet: hidingPlanet)
    }
    
    func getCore(completion: @escaping Completion) {
        completion(.init(planets: planets, vehicles: vehicles, strategy: findStrategy))
    }
}
