import FindingFalconeCore

/// Concrete API sourced implementation of `FindFalconeProvider`
public struct FindFalconeAPIProvider: FindFalconeProvider {
    let planetsProvider  = PlanetListAPIProvider()
    let vehiclesProvider = VehicleListAPIProvider()
    let findStrategy     = FindFalconeAPIStrategy()
    
    public init() {}
    
    public func getCore(completion: @escaping Completion) {
        FindFalconeCustomProvider(planetsProvider: planetsProvider,
                                  vehiclesProvider: vehiclesProvider,
                                  findStrategy: findStrategy)
            .getCore(completion: completion)
    }
}
