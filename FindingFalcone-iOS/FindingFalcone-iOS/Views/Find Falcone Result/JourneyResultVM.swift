protocol JourneyResultVM {
    var status: PlanetFoundStatus { get }
    var websiteText: String { get }
    var resultText: String { get }
    var startAgainText: String { get }
    var imageName: String? { get }
    
    var statusUpdated: VoidHandler? { get set }
    
    func start()
}
