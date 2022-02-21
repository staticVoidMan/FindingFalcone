/// Constants indicating the current state of the Planet search process
enum PlanetFoundStatus: Equatable {
    /// Planet search is In-Progress
    case inProgress
    
    /// Planet has been found
    ///
    /// Contains the name of the Planet
    case found(_ planetName: String)
    
    /// Planet search was completed & planet was not found
    case notFound
}
