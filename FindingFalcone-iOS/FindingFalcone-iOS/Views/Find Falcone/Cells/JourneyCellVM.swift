protocol JourneyCellVM {
    var destinationTitleText: String { get }
    var planetTitleText: String { get }
    var vehicleTitleText: String { get }
    var planetSubtitleText: String { get }
    var vehicleSubtitleText: String { get }
    
    var readyStatus: ReadyStatus { get }
    
    var planetImageName: String { get }
    var vehicleImageName: String { get }
    
    var isPlanetSelected: Bool { get }
}
