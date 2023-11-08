//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 28.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase


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
            
            self.saveImageToFirebase(completion: completion)
            
        }
    }
    
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        
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
                
                let imageUrl = url?.absoluteString ?? ""
                
                self.bindableIsRegistering.value = false
                print("Photo has been uploaded to the FireStore and url is --> \(url?.absoluteString ?? "") ")
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            }
            
            
        }
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
//        let uid = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let documentData = ["fullname": fullName ?? "", "uid": uid, "image1Url": imageUrl]
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { err in
            if let err = err {
                completion(err)
                return
            }

            completion(nil)
        }
    }
}
