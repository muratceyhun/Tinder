//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit


class MatchesMessagesController: UICollectionViewController {
    
 
    let customNavBar: UIView = {
        
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
        
        let navBar = UIView()
        navBar.backgroundColor = .white
        navBar.layer.shadowOpacity = 0.2
        navBar.layer.shadowRadius = 8
        navBar.layer.shadowOffset = .init(width: 0, height: 10)
        navBar.layer.shadowColor = UIColor.black.cgColor
        
        let hStackView = UIStackView(arrangedSubviews: [messageLabel, feedLabel])
        hStackView.distribution = .fillEqually
    
        navBar.addSubview(iconImageView)
        navBar.addSubview(hStackView)
        iconImageView.anchor(top: navBar.topAnchor, leading: nil, bottom: hStackView.topAnchor, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 44, height: 44))
        iconImageView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        hStackView.anchor(top: iconImageView.bottomAnchor, leading: navBar.leadingAnchor, bottom: nil, trailing: navBar.trailingAnchor, size: .init(width: 0, height: 70))
                
        return navBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
    }
}
