//
//  MatchView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 6.12.2023.
//

import UIKit

class MatchView: UIView {
    
    
    fileprivate let currentUserImageView: UIImageView = {
        let iw = UIImageView(image: #imageLiteral(resourceName: "mck2"))
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        iw.layer.borderWidth = 2
        iw.layer.borderColor = UIColor.white.cgColor
        return iw
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let iw = UIImageView(image: #imageLiteral(resourceName: "bsra"))
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        iw.layer.borderWidth = 2
        iw.layer.borderColor = UIColor.white.cgColor
        return iw
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 140, height: 140))
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 70
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = 70
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
          
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.visualEffectView.alpha = 1
        } completion: { _ in
            
        }

    }
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
