//
//  SettingsCell.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.11.2023.
//

import UIKit


class SettingsCell: UITableViewCell {
    
    
    class SettingsTextField: UITextField {
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 42)
        }
    }
    
    
    let textField: SettingsTextField = {
        let tf = SettingsTextField()
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        addSubview(textField)
        textField.fillSuperview()

    }
     
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
