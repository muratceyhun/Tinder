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

    
    let cardViewModels =
    ([
        User(name: "Ceyhun", age: 30, profession: "Engineer", imageNames: ["mck1", "mck2"]),
        User(name: "Büşra", age: 27, profession: "Architect", imageNames: ["bsra"]),
//        Advertiser(title: "Slide Out Menu", brandName: "Let's Build That App", posterPhotoName: "slide_out_menu_poster"),
//        User(name: "Ceyhun", age: 30, profession: "Engineer", imageNames: ["mck1", "mck2"]),
//        User(name: "Büşra", age: 27, profession: "Architect", imageNames: ["bsra"]),
//        User(name: "Ceyhun", age: 30, profession: "Engineer", imageNames: ["mck1", "mck2"]),
//        User(name: "Büşra", age: 27, profession: "Architect", imageNames: ["bsra"])
    ] as [ProducesCardViewModel]).map { producer in
        return producer.toCardViewModel()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupDummyCards()
    }
    
    
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView()
            
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
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

