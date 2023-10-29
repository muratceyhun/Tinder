//
//  RegistrationController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 25.10.2023.
//

import UIKit
import FirebaseAuth
import Firebase
import JGProgressHUD


extension RegistrationController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
//        registrationViewModel.image = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


class RegistrationController: UIViewController {
    
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    
    let fullNameTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Please enter a name"
        tx.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tx.backgroundColor = .white

        return tx
    }()
    
    let emailTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Please enter an e-mail"
        tx.keyboardType = .emailAddress
        tx.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tx.backgroundColor = .white

        return tx
    }()
    
    let passwordTextField: CustomTextField = {
        let tx = CustomTextField(padding: 16)
        tx.placeholder = "Password"
        tx.isSecureTextEntry = true
        tx.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tx.backgroundColor = .white

        return tx
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField ==  emailTextField{
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
       
        let isFormValid = fullNameTextField.hasText && emailTextField.hasText && passwordTextField.hasText ? true : false

        if isFormValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .lightGray
            registerButton.setTitleColor(.gray, for: .normal)
        }
    }

    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.setTitle("Register", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    @objc fileprivate func handleRegister() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                print("ERROR:", err)
                self.showHUDWithError(error: err)
                return
            }
            
            print("Registered successfully USER:", res?.user.uid ?? "")
        }
        
    }
    
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 4)
        
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        registrationViewModel.bindableIsFormValid.bind { [weak self] isFormValid in
            
            guard let isFormValid = isFormValid else {return}
            
            self?.registerButton.isEnabled = isFormValid
            if isFormValid {
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
                self?.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self?.registerButton.backgroundColor = .lightGray
                self?.registerButton.setTitleColor(.gray, for: .normal)
           
            }
        }
//        registrationViewModel.isFormValidObserver = { [weak self] isFormValid in
//
//            self?.registerButton.isEnabled = isFormValid
//            if isFormValid {
//                self?.registerButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
//                self?.registerButton.setTitleColor(.white, for: .normal)
//            } else {
//                self?.registerButton.backgroundColor = .lightGray
//                self?.registerButton.setTitleColor(.gray, for: .normal)
//
//            }
//
//        }
        
        
        registrationViewModel.bindableImage.bind { [weak self] image in
            self?.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
//
//        registrationViewModel.imageObserver = { [weak self] image in
//
//            self?.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
//
//        }
    }
    
    override func viewWillLayoutSubviews() {
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupTapGesture() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    
    fileprivate func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.view.transform = .identity
        }
    }
    
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = value.cgRectValue
//
//        print(value)
//        print(keyboardFrame)
        
        let bottomSpaceFromRegisterButton = view.frame.height - overAllStackView.frame.origin.y - overAllStackView.frame.height
        let difference = bottomSpaceFromRegisterButton - keyboardFrame.height - 8
        self.view.transform = CGAffineTransform(translationX: 0, y: difference)
        
    }
    
    
    lazy var overAllStackView = UIStackView(arrangedSubviews: [selectPhotoButton,
                                                               verticalStackView
                                                   ])
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [fullNameTextField,
                                                                emailTextField,
                                                                passwordTextField,
                                                                registerButton])
    
    fileprivate func setupLayout() {
        
        view.addSubview(overAllStackView)
        overAllStackView.axis = .vertical
        verticalStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fillEqually
        overAllStackView.spacing = 8
        overAllStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overAllStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overAllStackView.axis = .horizontal
        } else {
            overAllStackView.axis = .vertical
        }
    }
    
    let gradientLayer = CAGradientLayer()

    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.9842070937, green: 0.3840646744, blue: 0.3643660843, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    
    }
}
