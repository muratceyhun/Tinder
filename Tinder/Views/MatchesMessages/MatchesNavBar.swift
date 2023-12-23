//
//  MatchesNavBar.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit

class MatchesNavBar: UIView {
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "app_icon"), for: .normal)
        button.tintColor = .gray
        return button
    }()

    let iconImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysOriginal))
        iv.tintColor = #colorLiteral(red: 0.9975348115, green: 0.4412100315, blue: 0.4593596458, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9975348115, green: 0.4412101507, blue: 0.4638410807, alpha: 1)
        return label
    }()
    
    
    let feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        backgroundColor = .white
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.black.cgColor

        let hStackView = UIStackView(arrangedSubviews: [messageLabel, feedLabel])
        hStackView.distribution = .fillEqually
        addSubview(backButton)
        addSubview(iconImageView)
        addSubview(hStackView)
        backButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 28, height: 28))
        backButton.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        iconImageView.anchor(top: topAnchor, leading: nil, bottom: hStackView.topAnchor, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 44, height: 44))
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hStackView.anchor(top: iconImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 70))
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
