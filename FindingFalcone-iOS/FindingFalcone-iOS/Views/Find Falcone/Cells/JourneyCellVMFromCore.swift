import UIKit
import FindingFalconeCore

struct JourneyCellVMFromCore: JourneyCellVM {
    let journeyIndex: Int
    let journey: FindFalcone.Journey?
    
    var planet: Planet? { journey?.planet }
    var vehicle: Vehicle? { journey?.vehicle }
    
    var isPlanetSelected: Bool { planet != nil }
    
    var destinationTitleText: String {
        let parameterized = LocalizedStringKey.destinationX
        return String(format: parameterized, journeyIndex + 1)
    }
    
    var planetSubtitleText: String {
        guard let distance = planet?.distance else { return  "" }
        let parameterized = LocalizedStringKey.distanceX
        return String(format: parameterized, distance)
    }
    
    var vehicleSubtitleText: String {
        guard let distance = vehicle?.distance,
              let speed = vehicle?.speed
        else { return  "" }
        let parameterized = LocalizedStringKey.vehicleStatsX
        return String(format: parameterized, distance, speed)
    }
    
    var planetTitleText: String {
        planet?.name.rawValue ?? LocalizedStringKey.selectPlanet
    }
    var vehicleTitleText: String {
        vehicle?.name.imageName.capitalized ?? LocalizedStringKey.selectVehicle
    }
    
    var readyStatus: ReadyStatus {
        if planet == nil && vehicle == nil {
            return .notReady
        } else if planet == nil || vehicle == nil {
            return .inProgress
        } else {
            return .ready
        }
    }
    
    var planetImageName: String { planet?.name.imageName ?? "planet_placeholder" }
    var vehicleImageName: String { vehicle?.name.imageName ?? "vehicle_placeholder"}
}
