//
//  CustomInputAccessoryView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 19.12.2023.
//

import LBTATools
import UIKit


class CustomInputAccessoryView: UIView {
    
    let textView = UITextView()
    let sendButton = UIButton(title: "Send", titleColor: .black, target: self)
    
    let placeHolder = UILabel(text: "Placeholder here", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    
    override var intrinsicContentSize: CGSize {
       return .zero
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.3, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
  
        
        textView.text = ""
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        
        //*********//
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        
        
        hstack(textView, sendButton.withSize(.init(width: 60, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(placeHolder)
        placeHolder.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 0))
        placeHolder.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    @objc fileprivate func handleTextChange() {
        placeHolder.isHidden = textView.text.count != 0
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
