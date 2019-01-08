import UIKit
import SwiftPhoneNumberFormatter

protocol LoginFormViewDelegate: class {
    func loginButtonDidTapped(authData: AuthData)
    func resetAccessButtonDidTapped()
    func unwrap()
    func wrap()
}

final class LoginFormView: UIView {
    
    var delegate: LoginFormViewDelegate?
    
    private let titleLabel = UILabel(frame: .zero).build { (obj) in
        obj.text = "Вход в Домофон"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 21)
        obj.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let numberDescriptionLabel = UILabel(frame: .zero).build { (obj) in
        obj.text = "Номер телефона"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let phoneTextField = PhoneFormattedTextField(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.autocorrectionType = .no
        obj.returnKeyType = .done
        obj.backgroundColor = .white
        obj.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        obj.prefix = "+7 "
        obj.layer.cornerRadius = 17.5
        obj.layer.sublayerTransform = CATransform3DMakeTranslation(14, 0, 0)
        obj.keyboardType = .decimalPad
        obj.keyboardAppearance = .dark
    }
    
    private let passwordDescriptionLabel = UILabel(frame: .zero).build { (obj) in
        obj.text = "Пароль"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let passwordTextField = RoundedTextField(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.autocorrectionType = .no
        obj.backgroundColor = .white
        obj.autocapitalizationType = .none
        obj.isSecureTextEntry = true
        obj.returnKeyType = .done
        obj.keyboardAppearance = .dark
    }
    
    private let loginButton = ConnectButton(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.setTitle("Войти", for: .normal)
        obj.backgroundColor = UIColor(hexString: "03A9F4") // TODO: - make color system
        obj.setTitleColor(.white, for: .normal)
        obj.isEnabled = false
    }
    
    private let loginButtonSpinner = UIActivityIndicatorView(style: .gray).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.hidesWhenStopped = true
    }
    
    private let accessRecoveryButton = UIButton(frame: .zero).build { (obj) in
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.setTitle("Получить доступ", for: .normal)
        obj.setTitleColor(UIColor(hexString: "03A9F4"), for: .normal) // TODO: - make color system
    }
    
    private struct Constrants {
        static let defaultCornerRadius: CGFloat = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(titleLabel)
        addSubview(numberDescriptionLabel)
        addSubview(phoneTextField)
        addSubview(passwordDescriptionLabel)
        addSubview(passwordTextField)
        addSubview(loginButton)
        loginButton.addSubview(loginButtonSpinner)
        addSubview(accessRecoveryButton)
        
        let loginButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(loginButtonDidTapped))
        loginButton.addGestureRecognizer(loginButtonTapGesture)
        
        let accessRecoveryTapGesture = UITapGestureRecognizer(target: self, action: #selector(accessRecoveryButtonDidTapped))
        accessRecoveryButton.addGestureRecognizer(accessRecoveryTapGesture)
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTapped))
        self.addGestureRecognizer(backgroundTapGesture)
        
        phoneTextField.addTarget(self, action: #selector(textFiledDidChange), for: .valueChanged)
        passwordTextField.addTarget(self, action: #selector(textFiledDidChange), for: .editingChanged)
        
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        
        backgroundColor = UIColor(hexString: "262D37") // TODO: - make color system
        layer.cornerRadius = Constrants.defaultCornerRadius

        titleLabel
            .topAnchor(equalTo: topAnchor, constant: 50)
            .centerXAnchor(equalTo: centerXAnchor)
        
        numberDescriptionLabel
            .topAnchor(equalTo: titleLabel.bottomAnchor, constant: 30)
            .leadingAnchor(equalTo: leadingAnchor, constant: 20)
        
        phoneTextField
            .topAnchor(equalTo: numberDescriptionLabel.bottomAnchor, constant: 12)
            .leadingAnchor(equalTo: leadingAnchor, constant: 20)
            .trailingAnchor(equalTo: trailingAnchor, constant: -20)
            .heightAnchor(equalTo: 35)
        
        passwordDescriptionLabel
            .topAnchor(equalTo: phoneTextField.bottomAnchor, constant: 20)
            .leadingAnchor(equalTo: leadingAnchor, constant: 20)
        
        passwordTextField
            .topAnchor(equalTo: passwordDescriptionLabel.bottomAnchor, constant: 12)
            .leadingAnchor(equalTo: leadingAnchor, constant: 20)
            .trailingAnchor(equalTo: trailingAnchor, constant: -20)
            .heightAnchor(equalTo: 35)
        
        loginButton
            .topAnchor(equalTo: passwordTextField.bottomAnchor, constant: 27)
            .leadingAnchor(equalTo: leadingAnchor, constant: 20)
            .trailingAnchor(equalTo: trailingAnchor, constant: -20)
            .heightAnchor(equalTo: 35)
        
        loginButtonSpinner
            .centerYAnchor(equalTo: loginButton.centerYAnchor)
            .trailingAnchor(equalTo: loginButton.trailingAnchor, constant: -20)
        
        accessRecoveryButton
            .centerXAnchor(equalTo: centerXAnchor)
            .topAnchor(equalTo: loginButton.bottomAnchor, constant: 20)
            .heightAnchor(equalTo: 30)
    }
    
    @objc func backgroundDidTapped() {
        endEditing(true)
        delegate?.wrap()
    }
    
    @objc func loginButtonDidTapped() {
        guard let authData = AuthData(phone: phoneTextField.phoneNumber(),
                                      password: passwordTextField.text) else {
            return
        }

        endEditing(true)
        delegate?.loginButtonDidTapped(authData: authData)
    }
    
    @objc func accessRecoveryButtonDidTapped() {
        endEditing(true)
        delegate?.resetAccessButtonDidTapped()
    }
    
    @objc func textFiledDidChange() {
        BottomInfoBanner.dismissAll()
        
        guard let phone = phoneTextField.phoneNumberWithoutPrefix(), let password = passwordTextField.text else {
            loginButton.isEnabled = false
            return
        }
        
        loginButton.isEnabled = phone.count > 9 && password.count > 2
    }
    
    func startSpinner() {
        loginButtonSpinner.startAnimating()
    }
    
    func stopSpinner() {
        loginButtonSpinner.stopAnimating()
    }
}

extension LoginFormView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.unwrap()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
