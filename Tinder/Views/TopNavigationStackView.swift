//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 9.10.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile"), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages"), for: .normal)
        fireImageView.contentMode = .scaleAspectFit
        
        [settingsButton, UIView(), UIView(), fireImageView, UIView(), UIView(), messageButton].forEach { v in
            addArrangedSubview(v)
        }

        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
