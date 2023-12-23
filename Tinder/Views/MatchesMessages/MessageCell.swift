//
//  MessageCell.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 23.12.2023.
//

import LBTATools
import UIKit

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.9019607902, green: 0.9019607902, blue: 0.9019607902, alpha: 1))

    
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFromCurrentUser {
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.0861729607, green: 0.7602494955, blue: 0.998857677, alpha: 1)
                textView.textColor = .white
                
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9019607902, green: 0.9019607902, blue: 0.9019607902, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.constant = -20

        
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
