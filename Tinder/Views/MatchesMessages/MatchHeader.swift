//
//  MatchHeader.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 23.12.2023.
//

import LBTATools
import UIKit
import Firebase

class MatchesHeader: UICollectionReusableView {
    
    
    class MatchesHorizontalController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
        
        weak var rootMatchesController: MatchesMessagesController?
        
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
                
        stack(stack(newMatchesLabel).padLeft(16), matchHorizontalController.view, stack(messagesLabel).padLeft(16), spacing: 8).withMargins(.init(top: 20, left: 0, bottom: 8, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
