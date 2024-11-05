import UIKit

final class HoldingsCoordinator {
    private let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let viewController = HoldingsViewController(viewModel: HoldingsViewModel(useCase: FetchHoldingsUseCaseImpl(repository: FetchHoldingsRepository())))
        navigation.setViewControllers([viewController], animated: false)
    }
}
