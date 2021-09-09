import Firebase
import UIKit

class SignInController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - UIElements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "E-mail")
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let passwordTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "lock"), textField: passwordTextField)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Selectors
    
    @objc func handleShowSignUp() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helper Functions
    
    func setupView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundColor
        
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        stackView.addArrangedSubview(emailContainerView)
        stackView.addArrangedSubview(passwordContainerView)
        stackView.addArrangedSubview(loginButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        view.addSubview(dontHaveAccountButton)
        NSLayoutConstraint.activate([
            dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dontHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to log user in with \(error.localizedDescription)")
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let controller = window.rootViewController as? HomeController else { return }
            controller.configureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
