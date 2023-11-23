//
//  SettingsController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.11.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD
import SDWebImage


protocol SettingsControllerDelegate {
    func didSaveSettings()
}


class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  

    var delegate: SettingsControllerDelegate?
    
    
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
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedPhoto?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/photos/\(fileName)")
        guard let uploadedData = selectedPhoto?.jpegData(compressionQuality: 0.75 ) else {return}
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Photo is loading..."
        hud.show(in: view)
        ref.putData(uploadedData) { _, err in
            
            if let err = err {
                hud.dismiss(animated: true)
                print("Failed to upload photo to storage", err)
                return
            }
            print("Photo has been uploaded successfully")
            ref.downloadURL { url, err in
                hud.dismiss(animated: true)
                if let err = err {
                    print("Failed to get photo url", err)
                    return
                }
                guard let url = url else {return}
                print("Photo has been uploaded in this url", url.absoluteString)
                
                if imageButton == self.image1Button {
                    self.user?.image1Url = url.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.image2Url = url.absoluteString
                } else {
                    self.user?.image3Url = url.absoluteString
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch current user", err)
                return
            }
            print(snapshot?.data())
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            
            self.tableView.reloadData()
            
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl1 = user?.image1Url, let url = URL(string: imageUrl1) {
            SDWebImageManager.shared.loadImage(with: url, progress: nil) { image, _, _, _, _, _ in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl2 = user?.image2Url, let url = URL(string: imageUrl2) {
            SDWebImageManager.shared.loadImage(with: url, progress: nil) { image, _, _, _, _, _ in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl3 = user?.image3Url, let url = URL(string: imageUrl3) {
            SDWebImageManager.shared.loadImage(with: url, progress: nil) { image, _, _, _, _, _ in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
    }
    
    lazy var header: UIView = {
        
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
    }()
    
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if slider.value >= ageRangeCell.maxSlider.value {
            ageRangeCell.maxSlider.value = slider.value
            ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
            self.user?.maxSeekingAge = Int(slider.value)
            slider.value = ageRangeCell.minSlider.value
        }
        ageRangeCell.minLabel.text = "Min \(Int(slider.value))"
        self.user?.minSeekingAge = Int(slider.value)
        
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if slider.value <= ageRangeCell.minSlider.value {
            slider.value = ageRangeCell.minSlider.value
        }
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            let minAge = user?.minSeekingAge ?? 18
            let maxAge = user?.maxSeekingAge ?? 50
            ageRangeCell.minLabel.text = "Min: \(minAge)"
            ageRangeCell.maxLabel.text = "Max: \(maxAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxSlider.value = Float(maxAge)

            return ageRangeCell
        }
        
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter a name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter a profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)

        case 3:
            cell.textField.placeholder = "Enter an age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }

        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
        
    }
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
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
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String: Any] =
        [
            "uid": uid,
            "fullname": user?.name ?? "",
            "image1Url": user?.image1Url ?? "",
            "image2Url": user?.image2Url ?? "",
            "image3Url": user?.image3Url ?? "",
            "age": user?.age ?? .zero,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? 18,
            "maxSeekingAge": user?.maxSeekingAge ?? 50
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings..."
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            if let err = err {
                print("Failed to save user data", err)
                return
            }
            hud.dismiss(animated: true)
            print("User data saved successfully")
            self.dismiss(animated: true)
            self.delegate?.didSaveSettings()
        }
        
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
        
    }
}
