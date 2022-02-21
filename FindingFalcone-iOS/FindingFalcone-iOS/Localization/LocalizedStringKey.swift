import Foundation

extension String {
    /// Computed property to simplify the localization logic
    ///
    /// Example: "hello".localized
    ///
    /// Will look for the localized text with the key "hello"
    var localized: String { NSLocalizedString(self, comment: "") }
}

/// Constants mapping a localized key to it's respective localized string from `Localizable.strings`
enum LocalizedStringKey {
    static var loadingResources = "LOADING_RESOURCES".localized
    
    static var findFalconeTitle = "FIND_FALCONE_TITLE".localized
    
    static var findFalconeWaitTitle = "FIND_FALCONE_WAIT_TITLE".localized
    static var findFalconeWaitMessage = "FIND_FALCONE_WAIT_MESSAGE".localized
    
    static var findFalconeHelp = "FIND_FALCONE_HELP".localized
    
    static var etaX = "ETA_X".localized
    
    static var findFalconeCTA = "FIND_FALCONE_CTA".localized
    
    static var somethingWentWrong = "SOMETHING_WENT_WRONG".localized
    static var planetUnavailable = "PLANET_UNAVAILABLE".localized
    static var vehicleUnavailable = "VEHICLE_UNAVAILABLE".localized
    
    static var findFalconeResultWait = "FIND_FALCONE_RESULT_WAIT".localized
    static var findFalconeResultSuccessX = "FIND_FALCONE_RESULT_SUCCESS_X".localized
    static var findFalconeResultFail = "FIND_FALCONE_RESULT_FAIL".localized
    
    static var startAgain = "START_AGAIN".localized
    
    static var destination = "DESTINATION".localized
    static var destinationX = "DESTINATION_X".localized
    
    static var distanceX = "DISTANCE_X".localized
    static var speedX = "SPEED_X".localized
    static var vehicleStatsX = "VEHICLE_STATS_X".localized
    
    static var selectPlanet = "SELECT_PLANET".localized
    static var selectVehicle = "SELECT_VEHICLE".localized
    
    static var distance = "DISTANCE".localized
    static var range = "RANGE".localized
    static var speed = "SPEED".localized
    static var count = "COUNT".localized
}
