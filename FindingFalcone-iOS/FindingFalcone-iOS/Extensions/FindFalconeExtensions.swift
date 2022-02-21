import FindingFalconeCore

extension Planet.Name {
    var imageName: String { self.rawValue.lowercased() }
}

extension Vehicle.Name {
    var imageName: String {
        switch self {
        case .pod: return "pod"
        case .rocket: return "rocket"
        case .shuttle: return "shuttle"
        case .ship: return "ship"
        }
    }
}
