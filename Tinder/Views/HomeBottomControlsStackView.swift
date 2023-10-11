//
//  HomeBottomControlsStackView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 9.10.2023.
//

import UIKit


class HomeBottomControlsStackView: UIStackView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let buttons = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { img in
            let button = UIButton(type: .system)
            button.setImage(img, for: .normal)
            return button
        }
        
        buttons.forEach { v in
            addArrangedSubview(v)
        }
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true


    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
