//
//  HomeController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.10.2023.
//

import UIKit
import Firebase
import JGProgressHUD


class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    
    var cardViewModels = [CardViewModel]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let registrationController = RegistrationController()
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch current user", err)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            self.fetchSwipes()
//            self.fetchUsersFromFirestore()
        }
     }
    
    var swipes = [String: Any]()
    
    fileprivate func fetchSwipes() {
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to get swipes", err)
                return
            }
            print("Swipes", snapshot?.data())
            
            guard let data = snapshot?.data() as? [String: Any] else {return}
            self.swipes = data
            self.fetchUsersFromFirestore()
            
        }
    }
    
    @objc fileprivate func handleRefresh() {
         
        fetchUsersFromFirestore()
    }
    
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
                
        let minAge = user?.minSeekingAge ?? 18
        let maxAge = user?.maxSeekingAge ?? 50
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isLessThanOrEqualTo: maxAge).whereField("age", isGreaterThanOrEqualTo: minAge)
        topCardView = nil
        query.getDocuments { snapshot, err in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users from Firestore", err)
                return
            }
            
            var previousCardView: CardView?
                        
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let notCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                
                if notCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    
    var topCardView: CardView?
    
    fileprivate func performSwiperAnimation(translation: CGFloat, angle: CGFloat) {
        
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
 
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        var cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwiperAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {

        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        let documentData: [String: Int] = [cardUID: didLike]
        
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch swipes", err)
                return
            }

            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { err in
                    if let err = err {
                        print("Failed to update swipes", err)
                        return
                    }
                    print("Swipes updated successfully...")
                    self.checkIfMatchExists(cardUID: cardUID)
                }
            } else {

                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { err in
                    if let err = err {
                        print("Failed to save swipes", err)
                        return
                    }
                print("Swipes saved successfully...")
                    self.checkIfMatchExists(cardUID: cardUID)
                }
            }

        }
    }
    
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        print("Detecting Match !!")
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { snapshot, err in
            if let err = err {
                print("Failed to get snapshot for checkingMatch", err)
                return
            }
            
            guard let data = snapshot?.data() else {return}
                    print(data)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                print("has matched...")
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Found a match"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 4)
            }
        }
    }

    
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwiperAnimation(translation: -700, angle: -15)
    }
    
    func didRemoveCardView(cardViewModel: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
 
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    @objc fileprivate func handleSettings() {
        
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    

    
    func didTapMoreInfo(cardViewModel: CardViewModel ) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
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
        let overallstackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallstackView.axis = .vertical
        view.addSubview(overallstackView)
        overallstackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallstackView.isLayoutMarginsRelativeArrangement = true
        overallstackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallstackView.bringSubviewToFront(cardsDeckView)
    }
}

