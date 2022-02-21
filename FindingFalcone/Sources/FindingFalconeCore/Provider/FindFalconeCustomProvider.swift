import Foundation

/// Concrete implementation of `FindFalconeProvider`
///
/// You specify the `PlanetListProvider`,  `VehicleListProvider`, & `FindFalconeStrategy`
///
/// The `getCore(completion:)` will return the core `FindFalcone` after fetching the required `Planet`s & `Vehicle`s
public class FindFalconeCustomProvider: FindFalconeProvider {
    let planetsProvider: PlanetListProvider
    let vehiclesProvider: VehicleListProvider
    let findStrategy: FindFalconeStrategy
    
    public init(planetsProvider: PlanetListProvider,
                vehiclesProvider: VehicleListProvider,
                findStrategy: FindFalconeStrategy) {
        self.planetsProvider = planetsProvider
        self.vehiclesProvider = vehiclesProvider
        self.findStrategy = findStrategy
    }
    
    public func getCore(completion: @escaping Completion) {
        let group = DispatchGroup()
        
        var planets = [Planet]()
        var vehicles = [Vehicle]()
        
        group.enter()
        planetsProvider.getList { (result) in
            switch result {
            case .success(let items):
                planets = items
            case .failure(let error):
                print(error)
            }
            
            group.leave()
        }
        
        group.enter()
        vehiclesProvider.getList { (result) in
            switch result {
            case .success(let items):
                vehicles = items
            case .failure(let error):
                print(error)
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) { [findStrategy] in
            let core = FindFalcone(planets: planets,
                                   vehicles: vehicles,
                                   strategy: findStrategy)
            completion(core)
        }
    }
}

