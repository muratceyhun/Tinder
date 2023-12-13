//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit
import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "mck2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
    
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
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

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesNavBar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items =
        [
            .red, .blue, .yellow, .purple, .brown
        ]
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        collectionView.contentInset.top = 120
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
