//
//  HomeBottomControlsStackView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 9.10.2023.
//

import UIKit


class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    let refreshButton = createButton(image: UIImage(named: "refresh_circle") ?? UIImage())
    let dislikeButton = createButton(image: UIImage(named: "dismiss_circle") ?? UIImage())
    let superLikeButton = createButton(image: UIImage(named: "super_like_circle") ?? UIImage())
    let likeButton = createButton(image: UIImage(named: "like_circle") ?? UIImage())
    let specialButton = createButton(image: UIImage(named: "boost_circle") ?? UIImage())

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let buttons = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { img in
            let button = UIButton(type: .system)
            button.setImage(img, for: .normal)
            return button
        }

        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { button in
            self.addArrangedSubview(button)
        }

    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
