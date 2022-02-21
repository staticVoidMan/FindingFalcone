import Foundation

/// An object to create/update/reset journeys in order to find Falcone
public class FindFalcone {
    public typealias JourneyID = UUID
    
    public struct Journey {
        public var planet: Planet?
        public var vehicle: Vehicle?
        
        public var isReady: Bool { planet != nil && vehicle != nil }
        
        var time: Int? {
            guard let distance = planet?.distance, let speed = vehicle?.speed else { return nil }
            let time = Double(distance)/Double(speed)
            return Int(time.rounded())
        }
        
        public init(planet: Planet? = nil, vehicle: Vehicle? = nil) {
            self.planet = planet
            self.vehicle = vehicle
        }
    }
    
    private let allPlanets: [Planet]
    private let allVehicles: [Vehicle]
    
    private var availablePlanets: [Planet]
    private var availableVehicles: [Vehicle]
    
    public var journeys = [JourneyID: Journey]()
    
    /// Specifies the maximum number of planets the user can configure (default is 4)
    public var maxPlanetsToVisit: Int = 4
    private var maxJourneysPossible: Int {
        min(maxPlanetsToVisit,
            allPlanets.count,
            allVehicles.reduce(0) { $0 + $1.count })
    }
    
    /// The total time for the journeys in ready state
    public var totalTime: Int {
        journeys.values.reduce(0) { total, journey in
            total + (journey.time ?? 0)
        }
    }
    
    public var isReadyToFindFalcone: Bool {
        journeys.values.filter { $0.isReady }.count == maxPlanetsToVisit
    }
    
    /// A strategy dependency that computes the final result
    let findStrategy: FindFalconeStrategy
    
    public init(planets: [Planet],
                vehicles: [Vehicle],
                strategy: FindFalconeStrategy) {
        self.allPlanets = planets
        self.availablePlanets = allPlanets
        
        self.allVehicles = vehicles
        self.availableVehicles = vehicles
        self.findStrategy = strategy
    }
    
}

extension FindFalcone {
    public func createJourney() throws -> JourneyID {
        guard journeys.count < maxJourneysPossible
        else { throw FindFalconeError.limitReached(maxJourneysPossible) }
        
        let id = JourneyID()
        journeys[id] = Journey()
        return id
    }
    
    public func removeJourney(id: JourneyID) {
        unassignPlanet(from: id)
        journeys[id] = nil
    }
    
    public func journeyDetails(of id: JourneyID) throws -> Journey {
        guard let journey = journeys[id] else { throw FindFalconeError.journeyDoesNotExist }
        return journey
    }
    
    public func doesJourneyExist(for id: JourneyID) -> Bool {
        return journeys[id] != nil
    }
}

extension FindFalcone {
    public func listAvailablePlanets() -> [Planet] {
        return availablePlanets
    }
    
    @discardableResult
    public func assignPlanet(_ planetName: Planet.Name, to journeyID: JourneyID) throws -> Planet {
        guard doesJourneyExist(for: journeyID) else { throw FindFalconeError.journeyDoesNotExist }
        
        unassignPlanet(from: journeyID)
        
        guard let planetIndex = availablePlanets.firstIndex(where: { $0.name == planetName })
        else { throw FindFalconeError.planetUnavailable }
        
        let planet = availablePlanets.remove(at: planetIndex)
        journeys[journeyID]?.planet = planet
        return planet
    }
    
    public func unassignPlanet(from journeyID: JourneyID) {
        guard let planet = journeys[journeyID]?.planet else { return }
        
        let insertIndex = availablePlanets.firstIndex { $0.distance > planet.distance } ?? availablePlanets.count
        availablePlanets.insert(planet, at: insertIndex)
        
        unassignVehicle(from: journeyID)
        journeys[journeyID]?.planet = nil
    }
}

extension FindFalcone {
    public func listAvailableVehicles(for journeyID: JourneyID) -> [Vehicle] {
        guard let planet = journeys[journeyID]?.planet else { return [] }
        return availableVehicles.filter { $0.distance >= planet.distance }
    }
    
    @discardableResult
    public func assignVehicle(_ name: Vehicle.Name, to journeyID: JourneyID) throws -> Vehicle {
        guard doesJourneyExist(for: journeyID) else { throw FindFalconeError.journeyDoesNotExist }
        guard let planet = journeys[journeyID]?.planet else { throw FindFalconeError.planetUnavailable }
        
        guard
            let vehicleIndex = availableVehicles.firstIndex(where: { $0.name == name && $0.count > 0 }),
            planet.distance <= availableVehicles[vehicleIndex].distance
        else { throw FindFalconeError.vehicleUnavailable }
        
        unassignVehicle(from: journeyID)
        
        let vehicle = availableVehicles[vehicleIndex]
        availableVehicles[vehicleIndex] = vehicle.updated(count: vehicle.count - 1)
        
        let vehicleToPlanet = Vehicle(name: vehicle.name,
                                      count: 1,
                                      distance: vehicle.distance,
                                      speed: vehicle.speed)
        journeys[journeyID]?.vehicle = vehicleToPlanet
        
        return vehicleToPlanet
    }
    
    public func unassignVehicle(from journeyID: JourneyID) {
        guard let vehicleName = journeys[journeyID]?.vehicle?.name,
              let index = availableVehicles.firstIndex(where: { $0.name == vehicleName })
        else { return }
        
        let vehicle = availableVehicles[index]
        availableVehicles[index] = vehicle.updated(count: vehicle.count + 1)
        
        journeys[journeyID]?.vehicle = nil
    }
}

extension FindFalcone {
    public func reset() {
        findStrategy.newSession()
        journeys.keys.forEach(removeJourney)
    }
    
    public func findFalcone(_ completion: @escaping (Planet.Name?) -> Void) {
        guard isReadyToFindFalcone else { return }
        
        var planets = [Planet.Name]()
        var vehicles = [Vehicle.Name]()
        for journey in journeys.values {
            planets.append(journey.planet!.name)
            vehicles.append(journey.vehicle!.name)
        }
        
        findStrategy.findFalcone(planets: planets, vehicles: vehicles, completion: completion)
    }
}
