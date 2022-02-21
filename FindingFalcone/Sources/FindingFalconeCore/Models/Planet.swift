public struct Planet {
    public enum Name: String, CaseIterable {
        case donlon   = "Donlon"
        case enchai   = "Enchai"
        case jebing   = "Jebing"
        case sapir    = "Sapir"
        case lerbin   = "Lerbin"
        case pingasor = "Pingasor"
    }
    
    public let name: Name
    public let distance: Int
    
    public init(name: Name, distance: Int) {
        self.name = name
        self.distance = distance
    }
}

extension Planet: Equatable {}

extension Planet: Decodable {}
extension Planet.Name: Decodable {}
