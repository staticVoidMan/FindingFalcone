import UIKit
import FindingFalconeCore

class JourneyResultCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parent: FindFalconeCoordinator?
    
    let core: FindFalcone
    
    init(navigationController: UINavigationController, core: FindFalcone) {
        self.navigationController = navigationController
        self.core = core
    }
    
    func start() {
        let vc = JourneyResultVC()
        vc.coordinator = self
        vc.viewModel = JourneyResultVMFromCore(core: core)
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// Navigation logic to show a URL in a browser
    func showWebsite(url: URL?) {
        guard let url = url,
              UIApplication.shared.canOpenURL(url)
        else { return }
        
        UIApplication.shared.open(url)
    }
    
    /// Navigation logic to Find-Falcone screen after resetting user choices
    func restart() {
        core.reset()
        
        UIView.transition(with: navigationController.view,
                          duration: 0.4,
                          options: .transitionFlipFromLeft) {
            self.navigationController.popViewController(animated: true)
        }
        
        parent?.childDidFinish(self)
    }
}
