/// Request data-transfer-object containing the user selected `Planet` & `Vehicle` choices
struct FindFalconeRequestTO: Encodable {
    let token: Token
    let planets: [String]
    let vehicles: [String]
    
    enum CodingKeys: String, CodingKey {
        case token
        case planets = "planet_names"
        case vehicles = "vehicle_names"
    }
}
