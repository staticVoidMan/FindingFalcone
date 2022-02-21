import Foundation
import FindingFalconeCore

struct SelectVehicleCellVM: ItemProviding, ItemSelectable {
    let item: Vehicle
    
    var imageName: String { item.name.imageName }
    
    var isSelectable: Bool { item.count > 0 }
    
    var distanceTitleText: String { LocalizedStringKey.range }
    var speedTitleText: String { LocalizedStringKey.speed }
    var countTitleText: String { LocalizedStringKey.count }
    
    var nameText: String { item.name.imageName.capitalized }
    var distanceText: String { String(format: LocalizedStringKey.distanceX, item.distance) }
    var speedText: String { String(format: LocalizedStringKey.speedX, item.speed) }
    var countText: String { "\(item.count)" }
}
