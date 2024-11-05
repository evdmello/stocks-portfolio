import UIKit

final class AppCoordinator {
    private let navigation: UINavigationController
    private var holdingsCoordinator: HoldingsCoordinator?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let coordinator = HoldingsCoordinator(navigation: navigation)
        coordinator.start()
        self.holdingsCoordinator = coordinator
    }
}
