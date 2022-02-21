import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class JourneyResultVMFromCoreTests: XCTestCase {
    func test_PlanetFoundScenario() {
        let sut = makeSUT(hidingPlanet: .donlon)
        
        let exp = expectation(description: "Expecting Success")
        sut.statusUpdated = {
            exp.fulfill()
            XCTAssertEqual(sut.status, .found("Donlon"))
            XCTAssertEqual(sut.resultText, String(format: LocalizedStringKey.findFalconeResultSuccessX, "DONLON"))
        }
        
        XCTAssertEqual(sut.status, .inProgress)
        XCTAssertEqual(sut.resultText, LocalizedStringKey.findFalconeResultWait)
        sut.start()
        wait(for: [exp], timeout: 1)
    }
    
    func test_PlanetNotFoundScenario() {
        let sut = makeSUT(hidingPlanet: nil)
        
        let exp = expectation(description: "Expecting Success")
        sut.statusUpdated = {
            exp.fulfill()
            XCTAssertEqual(sut.status, .notFound)
            XCTAssertEqual(sut.resultText, LocalizedStringKey.findFalconeResultFail)
        }
        
        sut.start()
        wait(for: [exp], timeout: 1)
    }
}

extension JourneyResultVMFromCoreTests {
    private func makeSUT(hidingPlanet: Planet.Name?) -> JourneyResultVMFromCore {
        let core = FindFalcone(planets: [],
                               vehicles: [],
                               strategy: FindFalconeStubStrategy(hidingPlanet: hidingPlanet))
        core.maxPlanetsToVisit = 0
        let sut = JourneyResultVMFromCore(core: core)
        return sut
    }
}
