import XCTest
import FindingFalconeCore
@testable import FindingFalcone_iOS

class LoadingVMFromCoreTests: XCTestCase {
    func test_InitialConditions() {
        let sut = LoadingVMFromCore(provider: FindFalconeStubProvider())
        XCTAssertEqual(sut.loadingText, LocalizedStringKey.loadingResources)
        XCTAssertNil(sut.didFinishLoading)
    }
    
    func test_CanLoadFromCore() {
        let sut = LoadingVMFromCore(provider: FindFalconeStubProvider())
        sut.didFinishLoading = { _ in
            XCTAssertTrue(true)
        }
        
        sut.load()
    }
}
