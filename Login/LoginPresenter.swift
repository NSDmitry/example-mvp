final class LoginPresenter {

    private weak var view: LoginViewControllerProtocol?
    private let router: LoginRouterProtocol?
    private let authorizationService: AuthServiceProtocol = AuthService()
    private let userService: UserServiceProtocol = UserService()
    private let pushService = PushService()
    
    init(router: LoginRouterProtocol, view: LoginViewControllerProtocol) {
        self.view = view
        self.router = router
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func authUser(authData: AuthData) {
        authorizationService.authUser(phone: authData.phone, password: authData.password, success: { [weak self] (userAccount) in
            self?.userService.save(user: userAccount)
            Analytics.event(AnalyticsKey.authorization)
            self?.view?.connectDone()
            self?.router?.openIntercoms(user: userAccount)
            self?.pushService.subscribeToTopics()
            }, failure: { error in
                let error = DomophoneError(error: error?.statusCode == 401 ? .loginFormAuthError : .loginFormUnknowError)
                self.view?.connectError(error: error)
        })
    }
    
    func openResetSmsViewController() {
        router?.openResetAccessViewController()
    }
    
    func openDebug() {
        router?.openDebugMenu()
    }
}
