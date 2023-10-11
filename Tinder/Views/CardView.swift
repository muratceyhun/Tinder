//
//  CardView.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 11.10.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "mck"))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {

        case .changed:
            handleChanged(gesture)

        case .ended:
            handleEnded()
        
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
