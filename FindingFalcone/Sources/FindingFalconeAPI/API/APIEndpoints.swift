/// Constants holding API endpoint details
enum APIEndpoints {
    /// Base API domain
    static let base         = "https://findfalcone.herokuapp.com"
    
    ///API to fetch all available `Planet`s
    ///
    /// - Method Type: GET
    /// - Response Object: `[Planet]`
    static let getPlanets   = "\(base)/planets"
    
    ///API to fetch all available `Vehicles`s
    ///
    /// - Method: GET
    /// - Response: `[Vehicle]`
    static let getVehicles  = "\(base)/vehicles"
    
    ///API to fetch a session `Token`
    ///
    /// - Method: GET
    /// - Response: `TokenResponseTO`
    static let getToken     = "\(base)/token"
    
    ///API to fetch an optional `Planet` representing the hiding planet of Falcone
    ///
    /// - Method: POST
    /// - Request: `FindFalconeRequestTO`
    /// - Response: `FindFalconeResponseTO`
    static let findFalcone  = "\(base)/find"
}
