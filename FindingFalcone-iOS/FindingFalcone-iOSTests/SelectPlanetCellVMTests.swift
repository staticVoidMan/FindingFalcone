import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class SelectPlanetCellVMTests: XCTestCase {
    func test_SelectablePlanet() {
        let sut = SelectPlanetCellVM(item: Planet(name: .donlon, distance: 100))
        XCTAssertEqual(sut.nameText, "Donlon")
        XCTAssertEqual(sut.distanceText, String(format: LocalizedStringKey.distanceX, 100))
        XCTAssertEqual(sut.isSelectable, true)
    }
}
