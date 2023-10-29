//
//  Bindable.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 29.10.2023.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
