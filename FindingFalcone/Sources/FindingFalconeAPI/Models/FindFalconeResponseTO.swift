import FindingFalconeCore

/// Response data-transfer-object holding the hidden planet information
struct FindFalconeResponseTO: Decodable {
    let planetName: Planet.Name?
    
    enum CodingKeys: String, CodingKey {
        case planetName = "planet_name"
    }
}
