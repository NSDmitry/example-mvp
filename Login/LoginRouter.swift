final class LoginRouter {
    weak var view: UIViewController?
}

extension LoginRouter: LoginRouterProtocol {
    func openResetAccessViewController() {
        let resetAccessStartViewController = AccessRecoveryStartConfigurator.configureModule()
        let resetAccessNavigationController = AccessRecoveryNavigationController(rootViewController: resetAccessStartViewController)
        view?.present(resetAccessNavigationController, animated: true, completion: nil)
    }
    
    func openIntercoms(user: UserAccount) {
        let viewController = IntercomsConfigurator.configureModule(user: user)
        let domophoneNavigationController = DomophoneNavigationController(rootViewController: viewController)
        view?.present(domophoneNavigationController, animated: true, completion: nil)
    }
    
    func openDebugMenu() {
        let debugViewController = DebugConfigurator.configureModule()
        view?.present(debugViewController, animated: true, completion: nil)
    }
}
