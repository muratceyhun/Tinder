//
//  SettingsController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.11.2023.
//

import UIKit


class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle("Select a Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedPhoto = info[.originalImage] as? UIImage
        (picker as? CustomImagePickerController)?.imageButton?.setImage(selectedPhoto?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .red
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        header.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems =
        [
            UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        
    }
    
    @objc fileprivate func handleLogout() {
        
    }
}
