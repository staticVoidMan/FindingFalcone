/// Constants indicating the type of alert to display
enum AlertStyle {
    /// Normal alert style
    case normal(title: String, message: String)
    
    /// Error alert style
    case error(title: String, message: String)
    
    /// Title content of the alert
    var title: String {
        switch self {
        case .normal(let title, _):
            return title
        case .error(let title, _):
            return title
        }
    }
    
    /// Message content of the alert
    var message: String {
        switch self {
        case .normal(_, let message):
            return message
        case .error(_, let message):
            return message
        }
    }
}
