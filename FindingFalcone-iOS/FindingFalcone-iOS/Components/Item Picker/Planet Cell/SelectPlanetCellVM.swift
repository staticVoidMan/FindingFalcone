import Foundation
import FindingFalconeCore

struct SelectPlanetCellVM: ItemProviding, ItemSelectable {
    let item: Planet
    
    var imageName: String { item.name.imageName }
    
    var distanceTitleText: String { LocalizedStringKey.distance }
    
    var nameText: String { item.name.rawValue }
    var distanceText: String { String(format: LocalizedStringKey.distanceX, item.distance) }
    
    var isSelectable: Bool { true }
}
