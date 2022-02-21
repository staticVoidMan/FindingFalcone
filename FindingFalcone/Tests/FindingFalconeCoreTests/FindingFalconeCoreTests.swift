import XCTest
@testable import FindingFalconeCore

final class FindingFalconeCoreTests: XCTestCase {
    func test_Should_CreateJourney() {
        let planet = Planet(name: .donlon, distance: 100)
        let vehicle = Vehicle(name: .pod, count: 1, distance: 1, speed: 1)
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        XCTAssertNoThrow(try sut.createJourney())
    }
    
    func test_ShouldNot_CreateJourneys_MoreThanDefinedMaxLimit() {
        let sut = FindFalcone(planets: Planet.Name.allCases.map { Planet(name: $0, distance: 100) },
                              vehicles: [Vehicle(name: .pod, count: 6, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        XCTAssertEqual(sut.journeys.count, 0)
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertThrowsError(try sut.createJourney())
        XCTAssertEqual(sut.journeys.count, sut.maxPlanetsToVisit)
    }
    
    func test_ShouldNot_CreateJourneys_MoreThanAvailablePlanets() {
        let sut = FindFalcone(planets: [Planet(name: .donlon, distance: 100)],
                              vehicles: [Vehicle(name: .pod, count: 2, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        XCTAssertEqual(sut.journeys.count, 0)
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertThrowsError(try sut.createJourney())
        XCTAssertEqual(sut.journeys.count,
                       1,
                       "Expected only one journey due to limited planets")
    }
    
    func test_ShouldNot_CreateJourneys_MoreThanAvailableVehicles() {
        let sut = FindFalcone(planets: [Planet(name: .donlon, distance: 100),
                                        Planet(name: .enchai, distance: 100)],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        XCTAssertEqual(sut.journeys.count, 0)
        XCTAssertNoThrow(try sut.createJourney())
        XCTAssertThrowsError(try sut.createJourney())
        XCTAssertEqual(sut.journeys.count,
                       1,
                       "Expected only one journey due to limited vehicles")
    }
    
    func test_Should_AllowRemovingJourney() throws {
        let distance = 100
        let planet = Planet(name: .donlon, distance: distance)
        let vehicle = Vehicle(name: .rocket,
                              count: 1,
                              distance: distance,
                              speed: 1)
        
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: journeyID))
        XCTAssertEqual(sut.listAvailablePlanets(), [])
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID)[0].count, 0)
        
        sut.removeJourney(id: journeyID)
        XCTAssertEqual(sut.listAvailablePlanets(), [planet])
    }
    
    func test_Should_CalculateTime() throws {
        let distance = 100
        let firstPlanet = Planet(name: .donlon, distance: distance)
        let secondPlanet = Planet(name: .enchai, distance: distance)
        
        let firstVehicle = Vehicle(name: .rocket,
                                   count: 1,
                                   distance: distance,
                                   speed: 2)
        let secondVehicle = Vehicle(name: .ship,
                                    count: 1,
                                    distance: distance,
                                    speed: 1)
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [firstVehicle, secondVehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let firstJourneyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: firstJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(firstVehicle.name, to: firstJourneyID))
        XCTAssertEqual(sut.totalTime, 50)
        
        let secondJourneyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(secondPlanet.name, to: secondJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(secondVehicle.name, to: secondJourneyID))
        XCTAssertEqual(sut.totalTime, 150)
    }
}

extension FindingFalconeCoreTests {
    func test_Should_ListAllPlanets() {
        let planets = [Planet(name: .donlon, distance: 100),
                       Planet(name: .enchai, distance: 200),
                       Planet(name: .jebing, distance: 300),
                       Planet(name: .lerbin, distance: 400),
                       Planet(name: .pingasor, distance: 500),
                       Planet(name: .sapir, distance: 600)]
        let sut = FindFalcone(planets: planets,
                              vehicles: [],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        XCTAssertEqual(sut.listAvailablePlanets(), [planets[0],
                                                    planets[1],
                                                    planets[2],
                                                    planets[3],
                                                    planets[4],
                                                    planets[5]])
    }
    
    func test_Should_AssignPlanet_ToJourney() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: journeyID))
        XCTAssertEqual(try sut.journeyDetails(of: journeyID).planet, firstPlanet)
    }
    
    func test_Should_ReAssignPlanet_ToJourney() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: journeyID))
        XCTAssertNoThrow(try sut.assignPlanet(secondPlanet.name, to: journeyID))
        XCTAssertEqual(sut.listAvailablePlanets(), [firstPlanet])
    }
    
    func test_Should_Allow_UnassignPlanet() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: journeyID))
        XCTAssertEqual(sut.listAvailablePlanets(), [secondPlanet])
        
        sut.unassignPlanet(from: journeyID)
        XCTAssertEqual(sut.listAvailablePlanets(),
                       [firstPlanet, secondPlanet],
                       "Expected planets to be restored to original")
    }
    
    func test_UnassignPlanet_Should_UnassignVehicle() throws {
        let planet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 100)
        let vehicle = Vehicle(name: .pod,
                              count: 2,
                              distance: 100,
                              speed: 1)
        
        let sut = FindFalcone(planets: [planet, secondPlanet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let firstJourneyID = try sut.createJourney()
        let secondJourneyID = try sut.createJourney()
        
        XCTAssertNoThrow(try sut.assignPlanet(planet.name, to: firstJourneyID))
        XCTAssertNoThrow(try sut.assignPlanet(secondPlanet.name, to: secondJourneyID))
        
        XCTAssertEqual(sut.listAvailableVehicles(for: secondJourneyID), [vehicle])
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: firstJourneyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: secondJourneyID),
                       [vehicle.updated(count: 1)],
                       "Expected vehicle count to reduce")
        sut.unassignPlanet(from: firstJourneyID)
        XCTAssertEqual(sut.listAvailableVehicles(for: secondJourneyID),
                       [vehicle],
                       "Expected vehicle count to be restored to original")
    }
    
    func test_Should_FetchJourneyDetails() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: journeyID))
        
        let journey = try sut.journeyDetails(of: journeyID)
        XCTAssertEqual(journey.planet, firstPlanet)
        XCTAssertEqual(journey.vehicle, nil)
    }
    
    func test_ShouldNot_AssignDuplicatePlanet_ToOtherJourney() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 2, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let firstJourneyID = try sut.createJourney()
        let secondJourneyID = try sut.createJourney()
        
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: firstJourneyID))
        XCTAssertThrowsError(try sut.assignPlanet(firstPlanet.name, to: secondJourneyID),
                             "Should not assign same planet to multiple journeys")
    }
    
    func test_Should_ListRemainingPlanets_AfterAssigningOnePlanet() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [Vehicle(name: .pod, count: 1, distance: 100, speed: 1)],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: journeyID))
        XCTAssertEqual(sut.listAvailablePlanets(), [secondPlanet], "Expected unassigned planets")
    }
}

extension FindingFalconeCoreTests {
    func test_Should_ListReachableVehicles_ForJourney() throws {
        let planetDistance = 100
        let planet = Planet(name: .donlon, distance: planetDistance)
        
        let unreachableVehicle = Vehicle(name: .pod,
                                         count: 1,
                                         distance: planetDistance - 1,
                                         speed: 1)
        let reachableVehicle_1 = Vehicle(name: .shuttle,
                                         count: 1,
                                         distance: planetDistance,
                                         speed: 1)
        let reachableVehicle_2 = Vehicle(name: .ship,
                                         count: 1,
                                         distance: planetDistance + 1,
                                         speed: 1)
        
        let sut = FindFalcone(planets: [planet],
                              vehicles: [unreachableVehicle,
                                         reachableVehicle_1,
                                         reachableVehicle_2],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID), [reachableVehicle_1,
                                                                   reachableVehicle_2])
    }
    
    func test_ShouldNot_ListVehicles_IfPlanetNotSelected() throws {
        let planet = Planet(name: .donlon, distance: 100)
        let vehicle = Vehicle(name: .pod,
                              count: 1,
                              distance: 100,
                              speed: 1)
        
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID), [])
    }
    
    func test_Should_AssignVehicle_ToJourney_IfCountAndDistanceValid() throws {
        let planetDistance = 100
        let planet = Planet(name: .donlon, distance: planetDistance)
        let vehicle = Vehicle(name: .rocket,
                              count: 1,
                              distance: planetDistance,
                              speed: 1)
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
        let assignedVehicle = try sut.assignVehicle(.rocket, to: journeyID)
        XCTAssertEqual(assignedVehicle.name, .rocket)
        XCTAssertEqual(assignedVehicle.count, 1)
        XCTAssertEqual(assignedVehicle.distance, vehicle.distance)
        XCTAssertEqual(assignedVehicle.speed, vehicle.speed)
    }
    
    func test_Should_ReAssignVehicle_ToJourney() throws {
        let planetDistance = 100
        let planet = Planet(name: .donlon, distance: planetDistance)
        let firstVehicle = Vehicle(name: .rocket,
                                   count: 1,
                                   distance: planetDistance,
                                   speed: 1)
        let secondVehicle = Vehicle(name: .ship,
                                    count: 1,
                                    distance: planetDistance,
                                    speed: 1)
        let sut = FindFalcone(planets: [planet],
                              vehicles: [firstVehicle, secondVehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(planet.name, to: journeyID))
        XCTAssertNoThrow(try sut.assignVehicle(firstVehicle.name, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID),
                       [firstVehicle.updated(count: 0),
                        secondVehicle],
                       "Vehicle count mismatch")
        XCTAssertNoThrow(try sut.assignVehicle(secondVehicle.name, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID),
                       [firstVehicle,
                        secondVehicle.updated(count: 0)],
                       "Vehicle count mismatch")
    }
    
    func test_Should_Allow_UnassignVehicle() throws {
        let planet = Planet(name: .donlon, distance: 100)
        let vehicle = Vehicle(name: .pod,
                              count: 1,
                              distance: 100,
                              speed: 1)
        
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        
        XCTAssertNoThrow(try sut.assignPlanet(planet.name, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID), [vehicle])
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID),
                       [vehicle.updated(count: 0)],
                       "Vehicle count mismatch")
        sut.unassignVehicle(from: journeyID)
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID),
                       [vehicle],
                       "Expected original vehicle count")
    }
    
    func test_ShouldNot_AssignVehicle_ToJourney_IfCountUnavailable() throws {
        let planetDistance = 100
        let planets = [Planet(name: .donlon, distance: planetDistance),
                       Planet(name: .enchai, distance: planetDistance)]
        let firstVehicle = Vehicle(name: .pod,
                                   count: 1,
                                   distance: planetDistance,
                                   speed: 1)
        let secondVehicle = Vehicle(name: .rocket,
                                    count: 1,
                                    distance: planetDistance,
                                    speed: 1)
        let sut = FindFalcone(planets: planets,
                              vehicles: [firstVehicle, secondVehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let firstJourneyID = try sut.createJourney()
        let secondJourneyID = try sut.createJourney()
        
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: firstJourneyID))
        XCTAssertNoThrow(try sut.assignPlanet(.enchai, to: secondJourneyID))
        
        XCTAssertNoThrow(try sut.assignVehicle(.pod, to: firstJourneyID))
        XCTAssertThrowsError(try sut.assignVehicle(.pod, to: secondJourneyID))
    }
    
    func test_ShouldNot_AssignVehicle_ToJourney_IfDistanceUnreachable() throws {
        let planetDistance = 100
        let planet = Planet(name: .donlon, distance: planetDistance)
        let vehicle = Vehicle(name: .rocket,
                              count: 2,
                              distance: planetDistance - 1,
                              speed: 1)
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
        XCTAssertThrowsError(try sut.assignVehicle(.rocket, to: journeyID))
    }
    
    func test_ShouldNot_AssignVehicle_ToJourney_IfVehicleUnavailable() throws {
        let planetDistance = 100
        let planet = Planet(name: .donlon, distance: planetDistance)
        let vehicle = Vehicle(name: .rocket,
                              count: 1,
                              distance: planetDistance,
                              speed: 1)
        let sut = FindFalcone(planets: [planet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [.donlon]))
        
        let journeyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
        XCTAssertThrowsError(try sut.assignVehicle(.ship, to: journeyID))
        XCTAssertEqual(sut.listAvailableVehicles(for: journeyID), [vehicle])
    }
}

extension FindingFalconeCoreTests {
    func test_Should_FindFalcone() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        
        let vehicle = Vehicle(name: .shuttle,
                              count: 2,
                              distance: 200,
                              speed: 2)
        
        let hidingPlanet = firstPlanet.name
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [hidingPlanet]))
        sut.maxPlanetsToVisit = 2
        
        let firstJourneyID = try sut.createJourney()
        let secondJourneyID = try sut.createJourney()
        
        XCTAssertEqual(sut.totalTime, 0)
        XCTAssertEqual(sut.isReadyToFindFalcone, false)
        
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: firstJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: firstJourneyID))
        XCTAssertEqual(sut.totalTime, 50)
        XCTAssertEqual(sut.isReadyToFindFalcone, false)
        
        XCTAssertNoThrow(try sut.assignPlanet(secondPlanet.name, to: secondJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: secondJourneyID))
        XCTAssertEqual(sut.totalTime, 150)
        XCTAssertEqual(sut.isReadyToFindFalcone, true)
        
        let exp = expectation(description: "Find Hiding Planet")
        sut.findFalcone { result in
            exp.fulfill()
            XCTAssertEqual(result, hidingPlanet)
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_ShouldNot_FindFalcone() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 200)
        let thirdPlanet = Planet(name: .jebing, distance: 300)
        let fourthPlanet = Planet(name: .sapir, distance: 400)
        
        let vehicle = Vehicle(name: .ship,
                              count: 4,
                              distance: 400,
                              speed: 2)
        
        let hidingPlanet = Planet.Name.pingasor
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet, thirdPlanet, fourthPlanet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [hidingPlanet]))
        sut.maxPlanetsToVisit = 1
        
        let firstJourneyID = try sut.createJourney()
        XCTAssertEqual(sut.totalTime, 0)
        XCTAssertEqual(sut.isReadyToFindFalcone, false)
        
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: firstJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: firstJourneyID))
        
        let exp = expectation(description: "Find Hiding Planet")
        sut.findFalcone { result in
            exp.fulfill()
            XCTAssertEqual(result, nil)
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_Should_AllowReset() throws {
        let firstPlanet = Planet(name: .donlon, distance: 100)
        let secondPlanet = Planet(name: .enchai, distance: 100)
        let vehicle = Vehicle(name: .pod,
                              count: 1,
                              distance: 100,
                              speed: 1)
        
        let sut = FindFalcone(planets: [firstPlanet, secondPlanet],
                              vehicles: [vehicle],
                              strategy: FindFalconeStubStrategy(responses: [firstPlanet.name,
                                                                            secondPlanet.name]))
        sut.maxPlanetsToVisit = 1
        
        let oldJourneyID = try sut.createJourney()
        XCTAssertNoThrow(try sut.assignPlanet(firstPlanet.name, to: oldJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: oldJourneyID))
        
        sut.reset()
        XCTAssertThrowsError(try sut.journeyDetails(of: oldJourneyID))
        
        let newJourneyID = try sut.createJourney()
        XCTAssertEqual(sut.listAvailablePlanets().count, 2)
        XCTAssertNoThrow(try sut.assignPlanet(secondPlanet.name, to: newJourneyID))
        XCTAssertNoThrow(try sut.assignVehicle(vehicle.name, to: newJourneyID))
        
        let exp = expectation(description: "Find Hiding Planet")
        sut.findFalcone { result in
            exp.fulfill()
            XCTAssertEqual(result, secondPlanet.name)
        }
        wait(for: [exp], timeout: 5)
    }
}
