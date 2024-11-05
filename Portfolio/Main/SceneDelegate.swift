import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let navigation = UINavigationController()
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        configureCache()
        appCoordinator = AppCoordinator(navigation: navigation)
        appCoordinator?.start()
    }
    
    private func configureCache() {
        URLCache.shared = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
    }
}
