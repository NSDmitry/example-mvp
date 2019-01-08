import UIKit

final class LoginViewController: UIViewController {
    var presenter: LoginPresenterProtocol!
    
    private let backgroundImageView = UIImageView(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.image = UIImage(named: "loginBackground")
        obj.contentMode = .scaleAspectFill
    }
    
    private let debugEmptyView = UIView(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .clear
        obj.isUserInteractionEnabled = true
    }

    private var defaultLoginViewFrame: CGRect {
        return CGRect(center: view.center, size: CGSize(width: view.frame.width - 20, height: 400))
    }

    private var loginFormView = LoginFormView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(debugEmptyView)
        view.addSubview(loginFormView)
        
        let tapGestureRecognier = UITapGestureRecognizer(target: self, action: #selector(openDebugMenu))
        tapGestureRecognier.numberOfTapsRequired = 5
        debugEmptyView.addGestureRecognizer(tapGestureRecognier)
        
        self.title = ""
        
        loginFormView.delegate = self

        backgroundImageView
            .topAnchor(equalTo: view.topAnchor)
            .bottomAnchor(equalTo: view.bottomAnchor)
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)

        debugEmptyView
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .bottomAnchor(equalTo: view.bottomAnchor)
            .heightAnchor(equalTo: 150)

        loginFormView.frame = defaultLoginViewFrame
    }
    
    func connectedDone() {
        self.loginFormView.stopSpinner()
    }
    
    @objc func openDebugMenu() {
        presenter.openDebug()
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func connectDone() {
        self.loginFormView.stopSpinner()
    }
    
    func connectError(error: DomophoneError) {
        self.loginFormView.isUserInteractionEnabled = true
        BottomInfoBanner.showError(message: error.description)
        self.loginFormView.stopSpinner()
    }
}

extension LoginViewController: LoginFormViewDelegate {
    func loginButtonDidTapped(authData: AuthData) {
        loginFormView.startSpinner()
        loginFormView.isUserInteractionEnabled = false
        presenter.authUser(authData: authData)
    }
    
    func resetAccessButtonDidTapped() {
        presenter.openResetSmsViewController()
    }
    
    func wrap() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.loginFormView.frame = self.defaultLoginViewFrame
            self.loginFormView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func unwrap() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.loginFormView.frame = self.view.frame
            self.loginFormView.layoutIfNeeded()
        }, completion: nil)
    }
}
