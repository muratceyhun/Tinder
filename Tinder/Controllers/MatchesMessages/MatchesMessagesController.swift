//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit
import LBTATools
import Firebase



class RecentMessegaCell: LBTAListCell<UIColor> {
    
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "mck3"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "Username",font: .boldSystemFont(ofSize: 16) , textColor: .black)
    let messageTextLabel = UILabel(text: "What comes around goes around baby What comes around goes around baby", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    override var item: UIColor! {
        didSet {
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        userProfileImageView.layer.cornerRadius = 96 / 2
        userProfileImageView.clipsToBounds = true
        messageTextLabel.numberOfLines = 0
        hstack(userProfileImageView.withWidth(96).withHeight(96), stack(userNameLabel, messageTextLabel, spacing: 4), spacing: 20, alignment: .center).padLeft(16).padRight(16)
        
        addSeparatorView(leadingAnchor: userNameLabel.leadingAnchor)
    }
}



class MatchesMessagesController: LBTAListHeaderController<RecentMessegaCell, UIColor, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.frame.width, height: 256)
    }
    
    override func setupHeader(_ header: MatchesHeader) {
        header.matchHorizontalController.rootMatchesController = self
    }
    
    
    func didMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    let customNavBar = MatchesNavBar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white

        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        collectionView.contentInset.top = 120
        collectionView.verticalScrollIndicatorInsets.top = 120
        items = [.lightGray,.brown, .purple, .red, .black]
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 132)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
