//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 28.10.2023.
//

import UIKit


class RegistrationViewModel {
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity() }}
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
        
    }

    var isFormValidObserver: ((Bool) -> ())?
    
}
