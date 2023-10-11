//
//  ViewController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
        setupDummyCards()
    }
    
    
    fileprivate func setupDummyCards() {
        
        let cardView = CardView()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
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

