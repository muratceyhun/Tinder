//
//  CardView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 11.10.2023.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            nameLabel.attributedText = cardViewModel.attributedString
            imageView.image = UIImage(named: cardViewModel.imageName)
            imageView.contentMode = .scaleAspectFill
            nameLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    let threshold: CGFloat = 100
    
    // Encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "mck"))
    fileprivate let nameLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        setupGradientLayer()
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 16, right: 8))
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
    }
    

    
    fileprivate func setupGradientLayer() {
         
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
            
        case .began:
            superview?.subviews.forEach({ subview in
                subview.layer.removeAllAnimations()
            })

        case .changed:
            handleChanged(gesture)

        case .ended:
            handleEnded(gesture)
        
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180

        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
        
        
        
//        let translation = gesture.translation(in: nil)
//        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x < 0 ? -1 : 1
        
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
            if shouldDismissCard {
            
                let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
                self.transform = offScreenTransform
               
            } else {
                self.transform = .identity

            }
        } completion: { _ in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()

            }
            
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
