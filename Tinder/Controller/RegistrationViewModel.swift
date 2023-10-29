//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 28.10.2023.
//

import UIKit


class RegistrationViewModel {
    
    
    var bindableImage = Bindable<UIImage>()
    
    
    
    
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

//    var isFormValidObserver: ((Bool) -> ())?
    
    var bindableIsFormValid = Bindable<Bool>()
    
}
