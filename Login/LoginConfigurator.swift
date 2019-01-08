final class LoginConfigurator {
    static func configureModule() -> LoginViewController {
        let view = LoginViewController()
        let router = LoginRouter()
        let presenter = LoginPresenter(router: router, view: view)
        
        view.presenter = presenter
        router.view = view
        
        return view
    }
}
