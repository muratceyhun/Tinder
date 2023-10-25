//
//  CustomTextField.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 25.10.2023.
//

import UIKit


class CustomTextField: UITextField {
            
    var padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
            
     
    override var intrinsicContentSize: CGSize {
        .init(width: 0, height: 50)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}
