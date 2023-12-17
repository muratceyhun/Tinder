//
//  ChatLogController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 17.12.2023.
//

import LBTATools
import UIKit


struct Message {
    let text: String
}



class MessageCell: LBTAListCell<Message> {
    override var item: Message! {
        didSet {
            backgroundColor = .brown
            
            
        }
    }
}




class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    //**********//
    //without lazy var it appears error bc no guarantee which one is created first.
    private lazy var customNavBar = MessageNavBar(match: match)

    
    private var match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        
        collectionView.contentInset.top = 120
        
        items = [.init(text: "Bla Bla Bla Bla Bla Bla Bla Bla Bla")]
        
        
    }
    
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 100)
    }
}
