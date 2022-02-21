enum FindFalconeError: Error {
    /// When user tries to create more journeys than available planets & vehicles
    ///
    /// Example: 2 Planets & 1 vehicle available
    ///
    /// User tries to create 2 journeys. This is not possible as only 1 vehicle is available.
    case limitReached(_ count: Int)
    
    /// `JourneyID` is invalid
    case journeyDoesNotExist
    
    /// `Planet` is not selectable
    case planetUnavailable
    
    /// `Vehicle` is not selectable
    case vehicleUnavailable
}
