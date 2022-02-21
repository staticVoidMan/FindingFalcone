import UIKit

protocol Coordinator: AnyObject {
    /// Array of nested coordinators
    var children: [Coordinator] { get set }
    
    /// Associated Navigation Controller
    var navigationController: UINavigationController { get set }
    
    /// The entry point for the coordinator
    ///
    /// Used to set up the associated controller
    func start()
}
