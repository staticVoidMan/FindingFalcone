import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class JourneyCellVMFromCoreTests: XCTestCase {
    func test_CellWithoutPlanetAndVehicle() {
        let sut = JourneyCellVMFromCore(journeyIndex: 0, journey: nil)
        XCTAssertEqual(sut.destinationTitleText, String(format: LocalizedStringKey.destinationX, 1))
        XCTAssertEqual(sut.planetTitleText, LocalizedStringKey.selectPlanet)
        XCTAssertEqual(sut.vehicleTitleText, LocalizedStringKey.selectVehicle)
        XCTAssertTrue(sut.planetSubtitleText.isEmpty)
        XCTAssertTrue(sut.vehicleSubtitleText.isEmpty)
        XCTAssertEqual(sut.readyStatus, .notReady)
    }
    
    func test_CellContainingOnlyPlanet() {
        let sut = JourneyCellVMFromCore(journeyIndex: 0,
                                        journey: .init(planet: Planet(name: .donlon, distance: 100),
                                                       vehicle: nil))
        XCTAssertEqual(sut.planetTitleText, "Donlon")
        XCTAssertEqual(sut.planetSubtitleText, String(format: LocalizedStringKey.distanceX, 100))
        XCTAssertEqual(sut.readyStatus, .inProgress)
    }
    
    func test_CellContainingPlanetAndVehicle() {
        let sut = JourneyCellVMFromCore(journeyIndex: 0,
                                        journey: .init(planet: Planet(name: .donlon, distance: 100),
                                                       vehicle: Vehicle(name: .pod, count: 1, distance: 100, speed: 2)))
        XCTAssertEqual(sut.vehicleTitleText, "Pod")
        XCTAssertEqual(sut.vehicleSubtitleText, String(format: LocalizedStringKey.vehicleStatsX, 100, 2))
        XCTAssertEqual(sut.readyStatus, .ready)
    }
}
