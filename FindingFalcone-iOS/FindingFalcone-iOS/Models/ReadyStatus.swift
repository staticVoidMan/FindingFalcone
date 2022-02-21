/// Constants indicating the state of readiness
enum ReadyStatus {
    /// Not Ready
    ///
    /// Indicates that the object is not yet ready or waiting for user input
    case notReady
    /// In Progress
    ///
    /// Indicates that the object changes were started but still incomplete
    case inProgress
    /// Ready
    ///
    /// Indicates that the object is ready to use
    case ready
}

import UIKit
extension ReadyStatus {
    var color: UIColor {
        switch self {
        case .notReady   : return .red
        case .inProgress : return .orange
        case .ready      : return .green
        }
    }
}
