import Firebase
import UIKit
import GeoFire

class SignUpController: UIViewController {
    
    // MARK: - Variables
    private var location = LocationHandler.shared.locationManager.location
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Properties
    
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
    
    private let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: emailTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "person"), textField: fullNameTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "lock"), textField: passwordTextField)
    }()
    
 
    private lazy var accountTypeContainerView: UIView = {
        let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "person"), segmetedControl: accoountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // type user
    private let accoountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .white
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
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
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Selectors
    func setupView() {
        view.backgroundColor = .backgroundColor
        
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        stackView.addArrangedSubview(emailContainerView)
        stackView.addArrangedSubview(fullNameContainerView)
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
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateUserDataAndDismiss(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let controller = window.rootViewController as? HomeController else { return }
            controller.configureUI()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        let accountTypeIndex = accoountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to register user with error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email, "fullname": fullname, "accountType": accountTypeIndex] as [String : Any]
            
            if accountTypeIndex == 1 {
                let geofire = GeoFire(firebaseRef: REF_DRIVERS_LOCATIONS)
                guard let location = self.location else { return }
                
                geofire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                    self.updateUserDataAndDismiss(uid: uid, values: values)
                })
            }
            self.updateUserDataAndDismiss(uid: uid, values: values)
        }
    }
}
