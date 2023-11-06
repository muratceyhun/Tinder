//
//  HomeController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.10.2023.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()

    
    var cardViewModels = [CardViewModel]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        view.backgroundColor = .white
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    fileprivate func fetchUsersFromFirestore() {
        let query = Firestore.firestore().collection("users")
//        let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Dob")
        query.getDocuments { snapshot, err in
            if let err = err {
                print("Failed to fetch users from Firestore", err)
                return
            }
            
            snapshot?.documents.forEach({ documentSnapshot in
               let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupFirestoreUserCards()
            
        }
    }
    
    
    @objc fileprivate func handleSettings() {
        
        let registrationController = RegistrationController()
        registrationController.modalPresentationStyle = .fullScreen

        present(registrationController, animated: true)
    }
    
    
    fileprivate func setupFirestoreUserCards() {
        
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

