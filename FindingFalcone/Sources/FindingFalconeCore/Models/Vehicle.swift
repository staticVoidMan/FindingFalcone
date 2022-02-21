public struct Vehicle {
    public enum Name: String, CaseIterable {
        case pod     = "Space pod"
        case rocket  = "Space rocket"
        case shuttle = "Space shuttle"
        case ship    = "Space ship"
    }
    
    public let name: Name
    public let count: Int
    public let distance: Int
    public let speed: Int
    
    public init(name: Name, count: Int, distance: Int, speed: Int) {
        self.name = name
        self.count = count
        self.distance = distance
        self.speed = speed
    }
}

extension Vehicle {
    func updated(count: Int) -> Self {
        Self(name: self.name, count: count, distance: self.distance, speed: self.speed)
    }
}

extension Vehicle: Equatable {}

extension Vehicle: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case count = "total_no"
        case distance = "max_distance"
        case speed
    }
}
extension Vehicle.Name: Decodable {}
