import UIKit
import FindingFalconeCore

class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoadingVC()
        vc.viewModel = LoadingVMFromCore(provider: Providers.findFalcone)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// Navigation logic to display the Find-Falcone screen
    func showFindFalconeScreen(with core: FindFalcone) {
        core.maxPlanetsToVisit = Constants.numberOfJourneys
        
        let coordinator = FindFalconeCoordinator(navigationController: navigationController,
                                                 core: core)
        coordinator.parent = self
        
        children.append(coordinator)
        coordinator.start()
    }
}
