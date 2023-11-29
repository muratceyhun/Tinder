//
//  CardView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 11.10.2023.
//

import UIKit
import SDWebImage


protocol CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCardView(cardViewModel: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        
        didSet {
            let imageName = cardViewModel.imageUrls.first
            if let url = URL(string: imageName ?? "") {
                imageView.sd_setImage(with: url)
            }
            imageView.contentMode = .scaleAspectFill
            nameLabel.textAlignment = cardViewModel.textAlignment
            nameLabel.attributedText = cardViewModel.attributedString

            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (imageIndex, imageUrl) in
            if let imageUrl = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: imageUrl)
            }
            self?.barsStackView.arrangedSubviews.forEach { subview in
                subview.backgroundColor = self?.barDeselectedColor
            }
            self?.barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white

        }
    }

    
    let threshold: CGFloat = 100
    
    // Encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "mck1"))
    fileprivate let nameLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
//    var photoIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 1, alpha: 0.4)
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldSeeNextPhoto = tapLocation.x > (frame.width / 2) ? true : false
        
        if shouldSeeNextPhoto {
            cardViewModel.advanceNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
        
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo() {
   
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel )
        
    }
    
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        setupBarsStackView()
        setupGradientLayer()
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 16, right: 8))
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 24, right: 24), size: .init(width: 48, height: 48))
    }
    
    
    let barsStackView = UIStackView()

    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        barsStackView.layer.cornerRadius = 2
        barsStackView.clipsToBounds = true
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
//                superview?.subviews.last?.layer.removeAllAnimations()
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
        
        if shouldDismissCard {
            
            
            //hack solution
            
            guard let homeController = self.delegate as? HomeController else {return}
            
            
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.handleDislike()

            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1) {
                self.transform = .identity
            }
        }

        
        
//        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
//            if shouldDismissCard {
//
//                let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
//                self.transform = offScreenTransform
//
//            } else {
//                self.transform = .identity
//
//            }
//        } completion: { _ in
//            self.transform = .identity
//            if shouldDismissCard {
//                self.removeFromSuperview()
//
//
//                self.delegate?.didRemoveCardView(cardViewModel: self)
//
//            }
//
//        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
