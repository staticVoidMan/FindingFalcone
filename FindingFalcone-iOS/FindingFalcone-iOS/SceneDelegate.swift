import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: MainCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupNavigationBarAppearance()
        
        let nc = UINavigationController()
        coordinator = MainCoordinator(navigationController: nc)
        coordinator?.start()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nc
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func setupNavigationBarAppearance() {
        let foregroundColor = UIColor(named: "primary")!
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: foregroundColor]
        appearance.buttonAppearance = buttonAppearance
        
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

