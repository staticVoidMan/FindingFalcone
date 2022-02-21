import FindingFalconeCore
import UIKit

class FindFalconeVMFromCore: FindFalconeVM {
    let core: FindFalcone
    var journeys: [FindFalcone.JourneyID]
    
    var screenTitleText: String { LocalizedStringKey.findFalconeTitle }
    var notReadyAlertTitleText: String { LocalizedStringKey.findFalconeWaitTitle }
    var notReadyAlertMessageText: String { LocalizedStringKey.findFalconeWaitMessage }
    var findFalconeText: String { LocalizedStringKey.findFalconeCTA }
    var somethingWentWrongText: String { LocalizedStringKey.somethingWentWrong }
    var planetUnavailableText: String { LocalizedStringKey.planetUnavailable }
    var vehicleUnavailableText: String { LocalizedStringKey.vehicleUnavailable }
    var helpText: String { LocalizedStringKey.findFalconeHelp }
    
    var showAlert: ((AlertStyle?) -> Void)?
    var journeyUpdated: ((String, ReadyStatus) -> Void)?
    var updateRow: ((Int?) -> Void)?
    var showFalconeResult: (() -> Void)?
    
    init(core: FindFalcone) {
        self.core = core
        
        self.journeys = (1...core.maxPlanetsToVisit).compactMap { _ in
            try? core.createJourney()
        }
    }
    
    func refresh() {
        journeys = journeys.compactMap { (id) in
            core.doesJourneyExist(for: id) ? id : try? core.createJourney()
        }
        performUpdates(for: nil)
    }
    
    func showHelp() {
        let alert = AlertStyle.normal(title: "", message: helpText)
        showAlert?(alert)
    }
    
    func getJourney(for journeyID: FindFalcone.JourneyID) -> JourneyCellVM {
        let index = journeys.firstIndex(of: journeyID) ?? 0
        let journey = try? core.journeyDetails(of: journeyID)
        return JourneyCellVMFromCore(journeyIndex: index, journey: journey)
    }
    
    func getAvailablePlanets() -> [SelectPlanetCellVM] {
        let items = core.listAvailablePlanets()
        return items.map(SelectPlanetCellVM.init)
    }
    
    func getAvailableVehicles(for journeyID: FindFalcone.JourneyID) -> [SelectVehicleCellVM] {
        let items = core.listAvailableVehicles(for: journeyID)
        return items.map(SelectVehicleCellVM.init)
    }
    
    func assignPlanet(_ name: Planet.Name, for journeyID: FindFalcone.JourneyID) {
        do {
            try core.assignPlanet(name, to: journeyID)
            performUpdates(for: journeyID)
        } catch {
            let alert = AlertStyle.error(title: somethingWentWrongText,
                                         message: planetUnavailableText)
            showAlert?(alert)
        }
    }
    
    func assignVehicle(_ name: Vehicle.Name, for journeyID: FindFalcone.JourneyID) {
        do {
            try core.assignVehicle(name, to: journeyID)
            performUpdates(for: journeyID)
        } catch {
            let alert = AlertStyle.error(title: somethingWentWrongText,
                                         message: vehicleUnavailableText)
            showAlert?(alert)
        }
    }
    
    private func performUpdates(for journeyID: FindFalcone.JourneyID?) {
        let etaText = String(format: LocalizedStringKey.etaX, core.totalTime)
        let readyStatus: ReadyStatus = core.isReadyToFindFalcone ? .ready : .notReady
        journeyUpdated?(etaText, readyStatus)
        
        let index: Int? = {
            guard let journeyID = journeyID else { return nil }
            return journeys.firstIndex(of: journeyID)
        }()
        updateRow?(index)
    }
    
    func findFalcone() {
        if core.isReadyToFindFalcone {
            showFalconeResult?()
        } else {
            let alert = AlertStyle.error(title: notReadyAlertTitleText,
                                         message: notReadyAlertMessageText)
            showAlert?(alert)
        }
    }
}
