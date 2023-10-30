//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 28.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage


class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()

    
    
    
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }
//
//    var imageObserver: ((UIImage?) -> ())?
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity() }}
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    
    func performRegistration (completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else {return}
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                completion(err)
                return
            }
            
            print("Registered successfully USER:", res?.user.uid ?? "")
            
            let filename = UUID().uuidString
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            let ref = Storage.storage().reference(withPath: "/photos/\(filename)")
            
            ref.putData(imageData) { _, err in
                if let err = err {
                    completion(err)
                    return
                }
                
                let downloadUrl = ref.downloadURL { url, err in
                    if let err = err {
                        completion(err)
                        return
                    }
                    
                    self.bindableIsRegistering.value = false
                    print("Photo has been uploaded to the FireStore and url is --> \(url?.absoluteString ?? "") ")
                }
                
                
            }
           
            
            
        }
    }

    
    
}
