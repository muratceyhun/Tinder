//
//  RegistrationController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 25.10.2023.
//

import UIKit


class RegistrationController: UIViewController {
    
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    
    let fullNameTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Please enter a name"
        tx.backgroundColor = .white

        return tx
    }()
    
    let emailTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Please enter an e-mail"
        tx.keyboardType = .emailAddress
        tx.backgroundColor = .white

        return tx
    }()
    
    let passwordTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Password"
        tx.isSecureTextEntry = true
        tx.backgroundColor = .white

        return tx
    }()
    
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        setupGradientLayer()
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton,
                                                       fullNameTextField,
                                                       emailTextField,
                                                       passwordTextField,
                                                       registerButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
    
    fileprivate func setupGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9842070937, green: 0.3840646744, blue: 0.3643660843, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    
    }
}
