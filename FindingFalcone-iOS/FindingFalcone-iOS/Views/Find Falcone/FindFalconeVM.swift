import Foundation
import FindingFalconeCore

/// ViewModel protocol for `FindFalconeVC`
protocol FindFalconeVM {
    var screenTitleText: String { get }
    var findFalconeText: String { get }
    
    var journeys: [FindFalcone.JourneyID] { get }
    
    var showAlert: ((AlertStyle?)->Void)? { get set }
    var journeyUpdated: ((String,ReadyStatus)->Void)? { get set }
    var updateRow: ((Int?)->Void)? { get set }
    var showFalconeResult: (()->Void)? { get set }
    
    func refresh()
    func showHelp()
    
    func getJourney(for: FindFalcone.JourneyID) -> JourneyCellVM
    func getAvailablePlanets() -> [SelectPlanetCellVM]
    func getAvailableVehicles(for journeyID: FindFalcone.JourneyID) -> [SelectVehicleCellVM]
    func assignPlanet(_ name: Planet.Name, for journeyID: FindFalcone.JourneyID)
    func assignVehicle(_ name: Vehicle.Name, for journeyID: FindFalcone.JourneyID)
    func findFalcone()
}
