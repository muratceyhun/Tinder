//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit
import LBTATools
import Firebase


struct Match {
    let name: String
    let profileImageUrl: String
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "mck2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
    
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        stack(stack(profileImageView, alignment: .center), usernameLabel)
        
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesNavBar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white

//        items =
//        [
//            .init(name: "Murat", profileImageUrl: "url1"),
//            .init(name: "Teo", profileImageUrl: "url2"),
//            .init(name: "MCK", profileImageUrl: "url3"),
//            .init(name: "Lily", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-d1e52.appspot.com/o/photos%2F663DC4F2-0376-4437-9635-B64D764FA20C?alt=media&token=a8b23322-32c5-41dc-9634-109a4307149f")
//        ]
        fetchMatches()
        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        collectionView.contentInset.top = 120
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var match = items[indexPath.item]
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    
    fileprivate func fetchMatches() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches").getDocuments { querySnapshot, err in
            if let err = err {
                print("Failed to get matches messages", err)
                return
            }
            
            print("here are my matches messages")
            var matches = [Match]()
            querySnapshot?.documents.forEach({ documentSnapshot in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
                print(documentSnapshot.data())
            })
            
            self.items = matches
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
