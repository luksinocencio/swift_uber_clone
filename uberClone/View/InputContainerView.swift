import UIKit

class InputContainerView: UIView {
    init(image: UIImage?, textField: UITextField) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.87
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iv)
        NSLayoutConstraint.activate([
            iv.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iv.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            iv.widthAnchor.constraint(equalToConstant: 28),
            iv.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 8),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        
        let dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            dividerView.rightAnchor.constraint(equalTo: rightAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
