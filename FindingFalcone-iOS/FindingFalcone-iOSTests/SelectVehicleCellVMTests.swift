import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class SelectVehicleCellVMTests: XCTestCase {
    func test_SelectableVehicle() {
        let sut = SelectVehicleCellVM(item: Vehicle(name: .pod, count: 1, distance: 100, speed: 2))
        XCTAssertEqual(sut.nameText, "Pod")
        XCTAssertEqual(sut.distanceText, String(format: LocalizedStringKey.distanceX, 100))
        XCTAssertEqual(sut.speedText, String(format: LocalizedStringKey.speedX, 2))
        XCTAssertEqual(sut.countText, "1")
        XCTAssertEqual(sut.isSelectable, true)
    }
    
    func test_UnselectableVehicle() {
        let sut = SelectVehicleCellVM(item: Vehicle(name: .pod, count: 0, distance: 100, speed: 2))
        XCTAssertEqual(sut.countText, "0")
        XCTAssertEqual(sut.isSelectable, false)
    }
}
