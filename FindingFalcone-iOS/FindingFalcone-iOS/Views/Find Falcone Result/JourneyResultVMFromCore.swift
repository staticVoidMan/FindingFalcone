import FindingFalconeCore
import Foundation

class JourneyResultVMFromCore: JourneyResultVM {
    let core: FindFalcone
    
    var statusUpdated: VoidHandler?
    private(set) public var status: PlanetFoundStatus = .inProgress {
        didSet {
            statusUpdated?()
        }
    }
    
    init(core: FindFalcone) {
        self.core = core
    }
    
    var resultText: String {
        switch status {
        case .inProgress:
            return LocalizedStringKey.findFalconeResultWait
        case .found(let planetName):
            let parameterized = LocalizedStringKey.findFalconeResultSuccessX
            return String(format: parameterized, planetName.uppercased())
        case .notFound:
            return LocalizedStringKey.findFalconeResultFail
        }
    }
    
    var imageName: String? {
        switch status {
        case .inProgress:
            return nil
        case .found:
            return "found-meme"
        case .notFound:
            return "not_found-meme"
        }
    }
    
    var startAgainText: String { LocalizedStringKey.startAgain }
    var websiteText: String { "https://www.geektrust.in/coding-problem/frontend/space" }
    
    func start() {
        core.findFalcone { [weak self] planet in
            self?.status = {
                guard let planet = planet else { return .notFound }
                return .found(planet.rawValue)
            }()
        }
    }
}
