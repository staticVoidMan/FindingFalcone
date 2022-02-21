import XCTest
@testable import FindingFalconeCore

class FindFalconeCustomProviderTests: XCTestCase {
    func test_GetFindFalcone() {
        let planet  = Planet(name: .donlon, distance: 100)
        let vehicle = Vehicle(name: .pod, count: 1, distance: 100, speed: 1)
        
        let planetsProvider  = PlanetListStubProvider(items: [planet])
        let vehiclesProvider = VehicleListStubProvider(items: [vehicle])
        let findStrategy     = FindFalconeStubStrategy(responses: [.donlon])
        
        let coreProvider = FindFalconeCustomProvider(planetsProvider: planetsProvider,
                                                     vehiclesProvider: vehiclesProvider,
                                                     findStrategy: findStrategy)
        
        let exp = expectation(description: "Expect Core")
        coreProvider.getCore { sut in
            exp.fulfill()
            XCTAssertEqual(sut.listAvailablePlanets(), [planet])
            
            do {
                let journeyID = try sut.createJourney()
                XCTAssertNoThrow(try sut.assignPlanet(.donlon, to: journeyID))
                XCTAssertEqual(sut.listAvailableVehicles(for: journeyID), [vehicle])
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 1)
    }
}
