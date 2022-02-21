import UIKit
import FindingFalconeCore

class FindFalconeCoordinator: NSObject, Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    weak var parent: MainCoordinator?
    private let core: FindFalcone
    
    init(navigationController: UINavigationController, core: FindFalcone) {
        self.navigationController = navigationController
        self.core = core
        
        super.init()
        self.navigationController.delegate = self
    }
    
    func start() {
        let vc = FindFalconeVC()
        vc.coordinator = self
        vc.viewModel = FindFalconeVMFromCore(core: core)
        
        UIView.transition(with: navigationController.view,
                          duration: 0.4,
                          options: .transitionFlipFromRight) {
            self.navigationController.viewControllers[0] = vc
        }
    }
    
    func showFindFalconeResult() {
        let coordinator = JourneyResultCoordinator(navigationController: navigationController,
                                                   core: core)
        coordinator.parent = self
        
        children.append(coordinator)
        coordinator.start()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        navigationController.viewControllers.last!.present(alert, animated: true)
    }
    
    /// Navigation logic to display `ItemPickerVC` for the purpose of selecting a planet
    ///
    /// Returns the selected planet in a closure
    func selectPlanet(from items: [SelectPlanetCellVM], completion: @escaping (Planet) -> Void) {
        let cellIdentifier = "SelectPlanetCell"
        
        let vc = ItemPickerVC(nibName: "ItemPickerVC", bundle: nil)
        vc.title = LocalizedStringKey.selectPlanet
        
        vc.cellNib = UINib(nibName: "SelectPlanetCell", bundle: nil)
        vc.cellIdentifier = cellIdentifier
        
        let datasource = ItemPickerDatasource<SelectPlanetCellVM,SelectPlanetCell>(items: items, cellIdentifier: cellIdentifier)
        vc.datasource = datasource
        
        let gridSize = GridSize(rows: 3, columns: 2)
        vc.delegate = ItemPickerDelegate<SelectPlanetCellVM,SelectPlanetCell>(gridSize: gridSize, datasource: datasource) { (planet) in
            vc.dismiss(animated: false)
            completion(planet.item)
        }
        
        vc.modalPresentationStyle = .custom
        navigationController.viewControllers.last!.present(vc, animated: false)
    }
    
    /// Navigation logic to display `ItemPickerVC` for the purpose of selecting a vehicle for a given planet
    ///
    /// Returns the selected vehicle in a closure
    func selectVehicle(from items: [SelectVehicleCellVM], completion: @escaping (Vehicle) -> Void) {
        let cellIdentifier = "SelectVehicleCell"
        
        let vc = ItemPickerVC(nibName: "ItemPickerVC", bundle: nil)
        vc.title = LocalizedStringKey.selectVehicle
        
        vc.cellNib = UINib(nibName: "SelectVehicleCell", bundle: nil)
        vc.cellIdentifier = cellIdentifier
        
        let datasource = ItemPickerDatasource<SelectVehicleCellVM,SelectVehicleCell>(items: items, cellIdentifier: cellIdentifier)
        vc.datasource = datasource
        
        let gridSize = GridSize(rows: 2, columns: 2)
        vc.delegate = ItemPickerDelegate<SelectVehicleCellVM,SelectVehicleCell>(gridSize: gridSize, datasource: datasource) { (vehicle) in
            vc.dismiss(animated: false)
            completion(vehicle.item)
        }
        
        vc.modalPresentationStyle = .custom
        navigationController.viewControllers.last!.present(vc, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        guard let index = children.firstIndex(where: { $0 === child }) else { return }
        children.remove(at: index)
    }
}

extension FindFalconeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(fromVC)
        else { return }
        
        if let vc = fromVC as? JourneyResultVC {
            childDidFinish(vc.coordinator)
        }
    }
}
