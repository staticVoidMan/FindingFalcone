/// A protocol defining the strategy to find Falcone
public protocol FindFalconeStrategy {
    typealias CompletionResult = Planet.Name?
    typealias Completion = (CompletionResult)->Void
    
    /// Reset session for a new set of journeys & associated result
    func newSession()
    
    /// Returns an optional `Planet`
    ///
    /// If user has selected the answer correctly then the `Planet.Name` is returned else `nil` is returned
    func findFalcone(planets: [Planet.Name], vehicles: [Vehicle.Name], completion: @escaping Completion)
}
