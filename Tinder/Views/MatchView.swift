//
//  MatchView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 6.12.2023.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var currentUser: User! {
        didSet{
            
        }
    }
    
    
    var cardUID: String! {
        didSet {
            Firestore.firestore().collection("users").document(cardUID).getDocument { snapshot, err in
                if let err = err {
                    print("Failed to get cardUID", err)
                    return
                }
                
                guard let dictionary = snapshot?.data() else {return}
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.image1Url ?? "") else {return}
                self.cardUserImageView.sd_setImage(with: url)
                guard let currentUserImageUrl = URL(string: self.currentUser.image1Url ?? "") else {return}
                self.currentUserImageView.sd_setImage(with: currentUserImageUrl) { _, _, _, _ in
                    self.setupAnimation()
                }
                guard let userName = user.name else {return}
                self.descriptionLabel.text = "You and \(userName) have liked\neach other..."
            }
        }
    }
    
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other..."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    
    fileprivate let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mck2"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "bsra"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.alpha = 0
        return iv
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButtom(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupBlurView()
        setupLayout()
//        setupAnimation()
    }
    
    fileprivate func setupAnimation() {
        views.forEach({$0.alpha = 1})
        let angle = 30 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic) {
            //animation1
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)

            }
            //animation2
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.5) {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            }
        } completion: { _ in
            
        }
        UIView.animate(withDuration: 0.75, delay: 1.3 * 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        } completion: { _ in
            
        }

        
    }
    
    
    lazy var views = [itsAMatchImageView, descriptionLabel, currentUserImageView, cardUserImageView, sendMessageButton, keepSwipingButton]
    
    fileprivate func setupLayout() {
        
        views.forEach { v in
            addSubview(v)
            v.alpha = 0
        }
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 140, height: 140))
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 70
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = 70
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: leadingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 52))
        sendMessageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendMessageButton.layer.cornerRadius = 25
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 52 ))
          
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
