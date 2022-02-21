import FindingFalconeCore
import FindingFalconeAPI

/// Constants (on the main app boundary) containing configured providers that will be used throughout the app
enum Providers {
    static var findFalcone: FindFalconeProvider {
        FindFalconeAPIProvider()
    }
}
