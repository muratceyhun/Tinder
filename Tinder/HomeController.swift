//
//  HomeController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.10.2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    let users =
    [
        User(name: "Ceyhun", age: 30, profession: "Engineer", imageName: "mck"),
        User(name: "Eray", age: 29, profession: "Architect", imageName: "eray")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
        setupDummyCards()
    }
    
    
    fileprivate func setupDummyCards() {
        
//        (0..<5).forEach { _ in
//            let cardView = CardView()
//            cardsDeckView.addSubview(cardView)
//            cardView.fillSuperview()
//        }
        
        users.forEach { user in
            let cardView = CardView()
            cardsDeckView.addSubview(cardView)
            cardView.imageView.image = UIImage(named: user.imageName)
//            cardView.nameLabel.text = "\(user.name) \(user.age) \n\(user.profession)"
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
            cardView.nameLabel.attributedText = attributedText
            cardView.fillSuperview()
        }
        
        
    }
        
    //MARK: -Fileprivate
    
    fileprivate func setupLayout() {
        let overallstackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallstackView.axis = .vertical
        view.addSubview(overallstackView)
        overallstackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallstackView.isLayoutMarginsRelativeArrangement = true
        overallstackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallstackView.bringSubviewToFront(cardsDeckView)
    }
}

