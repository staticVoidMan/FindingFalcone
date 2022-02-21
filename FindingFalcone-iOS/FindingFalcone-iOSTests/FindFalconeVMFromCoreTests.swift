import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class FindFalconeVMFromCoreTests: XCTestCase {
    func test_InitialConditions() {
        let sut = makeSUT()
        
        var lastReadyStatus = ReadyStatus.ready
        var lastETAText = ""
        sut.journeyUpdated = { (etaText, readyStatus) in
            lastETAText = etaText
            lastReadyStatus = readyStatus
        }
        sut.refresh()
        
        XCTAssertEqual(sut.journeys.count, 4, "Should have exactly 4 journeys")
        XCTAssertEqual(sut.getAvailablePlanets().count, 6)
        XCTAssertEqual(lastReadyStatus, .notReady)
        XCTAssertEqual(lastETAText, String(format: LocalizedStringKey.etaX, 0))
    }
    
    func test_CanAssignPlanet() {
        let sut = makeSUT()
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        
        let journey = sut.getJourney(for: sut.journeys[0])
        XCTAssertEqual(journey.planetTitleText, "Donlon")
        XCTAssertEqual(journey.vehicleTitleText, LocalizedStringKey.selectVehicle, "Vehicle name not expected")
    }
    
    func test_CanReassignPlanet() {
        let sut = makeSUT()
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        sut.assignVehicle(.pod, for: sut.journeys[0])
        
        sut.assignPlanet(.enchai, for: sut.journeys[0])
        
        let journey = sut.getJourney(for: sut.journeys[0])
        XCTAssertEqual(journey.planetTitleText, "Enchai", "Expected planet to be reassigned")
        XCTAssertEqual(journey.vehicleTitleText, LocalizedStringKey.selectVehicle, "Vehicle name not expected")
    }
    
    func test_CanListVehiclesForPlanet() throws {
        let core = FindFalcone(planets: Planet.Name.allCases.map { Planet(name: $0, distance: 100) },
                               vehicles: [Vehicle(name: .pod    , count: 4, distance: 100, speed: 1),
                                          Vehicle(name: .rocket , count: 3, distance: 200, speed: 2),
                                          Vehicle(name: .shuttle, count: 2, distance: 300, speed: 3),
                                          Vehicle(name: .ship   , count: 1, distance: 400, speed: 4)],
                               strategy: FindFalconeStubStrategy())
        
        let sut = FindFalconeVMFromCore(core: core)
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        
        let vehicles = sut.core.listAvailableVehicles(for: sut.journeys[0])
        XCTAssertEqual(vehicles.count, 4)
        
        XCTAssertEqual(vehicles[0].name, .pod)
        XCTAssertEqual(vehicles[0].distance, 100)
        XCTAssertEqual(vehicles[0].speed, 1)
        XCTAssertEqual(vehicles[0].count, 4)
        
        XCTAssertEqual(vehicles[1].name, .rocket)
        XCTAssertEqual(vehicles[1].distance, 200)
        XCTAssertEqual(vehicles[1].speed, 2)
        XCTAssertEqual(vehicles[1].count, 3)
        
        XCTAssertEqual(vehicles[2].name, .shuttle)
        XCTAssertEqual(vehicles[2].distance, 300)
        XCTAssertEqual(vehicles[2].speed, 3)
        XCTAssertEqual(vehicles[2].count, 2)
        
        XCTAssertEqual(vehicles[3].name, .ship)
        XCTAssertEqual(vehicles[3].distance, 400)
        XCTAssertEqual(vehicles[3].speed, 4)
        XCTAssertEqual(vehicles[3].count, 1)
    }
    
    func test_CanAssignVehicleToPlanet() {
        let sut = makeSUT()
        
        var lastETAText = ""
        sut.journeyUpdated = { (etaText, _) in
            lastETAText = etaText
        }
        
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        sut.assignVehicle(.pod, for: sut.journeys[0])
        
        let journey = sut.getJourney(for: sut.journeys[0])
        XCTAssertEqual(journey.vehicleTitleText, "Pod")
        XCTAssertEqual(lastETAText, String(format: LocalizedStringKey.etaX, 100))
    }
    
    func test_CanReassignVehicleToPlanet() {
        let sut = makeSUT(vehicles: [Vehicle(name: .pod    , count: 2, distance: 100, speed: 1),
                                     Vehicle(name: .rocket , count: 2, distance: 200, speed: 2)])
        
        var lastETAText = ""
        sut.journeyUpdated = { (etaText, _) in
            lastETAText = etaText
        }
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        
        sut.assignVehicle(.pod, for: sut.journeys[0])
        XCTAssertEqual(lastETAText, String(format: LocalizedStringKey.etaX, 100))
        
        sut.assignVehicle(.rocket, for: sut.journeys[0])
        XCTAssertEqual(lastETAText, String(format: LocalizedStringKey.etaX, 50))
        
        let journey = sut.getJourney(for: sut.journeys[0])
        XCTAssertEqual(journey.vehicleTitleText, "Rocket", "Expected vehicle to be reassigned")
    }
    
    func test_CanListFewerVehicles_AfterAssigningOne() {
        let sut = makeSUT()
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        
        let before = sut.getAvailableVehicles(for: sut.journeys[0])
        XCTAssertEqual(before[0].countText, "4")
        
        sut.assignVehicle(.pod, for: sut.journeys[0])
        
        let after = sut.getAvailableVehicles(for: sut.journeys[0])
        XCTAssertEqual(after[0].countText, "3", "Expected vehicle count to reduce")
    }
    
    func test_CanAssignAllJourneys() {
        let sut = makeSUT(planets: [Planet(name: .donlon, distance: 100),
                                    Planet(name: .enchai, distance: 200),
                                    Planet(name: .jebing, distance: 300),
                                    Planet(name: .lerbin, distance: 400),
                                    Planet(name: .sapir, distance: 500),
                                    Planet(name: .pingasor, distance: 600)],
                          vehicles: [Vehicle(name: .pod, count: 2, distance: 200, speed: 1),
                                     Vehicle(name: .rocket, count: 1, distance: 300, speed: 4),
                                     Vehicle(name: .shuttle, count: 1, distance: 400, speed: 5),
                                     Vehicle(name: .ship, count: 2, distance: 600, speed: 10)])
        
        var lastReadyStatus = ReadyStatus.ready
        var lastETAText = ""
        sut.journeyUpdated = { (etaText, readyStatus) in
            lastETAText = etaText
            lastReadyStatus = readyStatus
        }
        
        sut.assignPlanet(.donlon, for: sut.journeys[0])
        sut.assignPlanet(.enchai, for: sut.journeys[1])
        sut.assignPlanet(.jebing, for: sut.journeys[2])
        sut.assignPlanet(.sapir, for: sut.journeys[3])
        
        sut.assignVehicle(.pod, for: sut.journeys[0])
        sut.assignVehicle(.rocket, for: sut.journeys[1])
        sut.assignVehicle(.shuttle, for: sut.journeys[2])
        XCTAssertEqual(lastReadyStatus, .notReady)
        sut.assignVehicle(.ship, for: sut.journeys[3])
        XCTAssertEqual(lastReadyStatus, .ready)
        
        XCTAssertEqual(lastETAText, "ETA - 260hrs")
    }
    
    func test_OnReset_CanRecreateJourneys() {
        let sut = makeSUT()
        
        let before = sut.journeys
        sut.assignPlanet(.donlon, for: before[0])
        XCTAssertEqual(sut.getAvailablePlanets().count, 5)
        
        sut.core.reset()
        sut.refresh()
        
        let after = sut.journeys
        XCTAssertTrue(before.allSatisfy { !after.contains($0) }, "Expect old journey ids to be renewed")
        XCTAssertEqual(sut.getAvailablePlanets().count, 6, "Expected available planets to be reset")
    }
}

extension FindFalconeVMFromCoreTests {
    private func makeSUT(planets: [Planet] = Planet.Name.allCases.map { Planet(name: $0, distance: 100) },
                         vehicles: [Vehicle] = [.init(name: .pod, count: 4, distance: 100, speed: 1)])
    -> FindFalconeVMFromCore {
        let core = FindFalcone(planets: planets, vehicles: vehicles, strategy: FindFalconeStubStrategy())
        core.maxPlanetsToVisit = 4
        return FindFalconeVMFromCore(core: core)
    }
}













































