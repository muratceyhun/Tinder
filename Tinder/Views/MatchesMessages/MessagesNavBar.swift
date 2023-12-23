//
//  MessagesNavBar.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 17.12.2023.
//

import LBTATools
import UIKit

class MessageNavBar: UIView {
    
    
    let userProileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "mck2"))
    let nameLabel = UILabel(text: "UserName", font: .systemFont(ofSize: 16), numberOfLines: 0)
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9992305636, green: 0.3497068882, blue: 0.356819123, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9992305636, green: 0.3497068882, blue: 0.356819123, alpha: 1))
    
    fileprivate var match: Match
    
    init(match: Match) {
        
        self.match = match
        nameLabel.text = match.name
        userProileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        super.init(frame: .zero)
        
        
        let vStack = stack(userProileImageView, nameLabel, spacing: 8, alignment: .center)
        hstack(backButton, vStack, flagButton, alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))

        
        backgroundColor = .white
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
