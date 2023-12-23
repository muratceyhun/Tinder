//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit
import LBTATools
import Firebase


class MatchesHeader: UICollectionReusableView {
    
    
    class MatchesHorizontalController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
        
        var rootMatchesController: MatchesMessagesController?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            
            fetchMatches()
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let match = items[indexPath.item]
            rootMatchesController?.didMatchFromHeader(match: match)
            
            
            
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            .init(top: 0, left: 0, bottom: 0, right: 16)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return .init(width: 120, height: 140)
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
        
    }
    
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9991757274, green: 0.4186983705, blue: 0.4429891109, alpha: 1))
    let matchHorizontalController = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9991757274, green: 0.4186983705, blue: 0.4429891109, alpha: 1))

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        stack(stack(newMatchesLabel).padLeft(16), matchHorizontalController.view, stack(messagesLabel).padLeft(16), spacing: 8).withMargins(.init(top: 20, left: 0, bottom: 20, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class MatchesMessagesController: LBTAListHeaderController<MatchCell, Match, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.frame.width, height: 256)
    }
    
    override func setupHeader(_ header: MatchesHeader) {
        header.matchHorizontalController.rootMatchesController = self
    }
    
    
    fileprivate func didMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }

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
