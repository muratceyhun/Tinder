//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 10.12.2023.
//

import UIKit
import LBTATools
import Firebase



struct RecentMessage {
    let name: String
    let uid: String
    let text: String
    let profileImageUrl: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}



class RecentMessegaCell: LBTAListCell<RecentMessage> {
    
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "mck3"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "Username",font: .boldSystemFont(ofSize: 16) , textColor: .black)
    let messageTextLabel = UILabel(text: "What comes around goes around baby What comes around goes around baby", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    override var item: RecentMessage! {
        didSet {
            userNameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
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



class MatchesMessagesController: LBTAListHeaderController<RecentMessegaCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = items[indexPath.item]
        let dictionary = ["name": recentMessage.name, "text": recentMessage.text, "uid": recentMessage.uid, "profileImageUrl": recentMessage.profileImageUrl]
        let match = Match(dictionary: dictionary)
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
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
    
    
    var recentMessagesDictionary = [String: RecentMessage]()
    
    var listener: ListenerRegistration?
    
    
    fileprivate func fetchRecentMessages() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages")
        listener = query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Failed to fetch recent messages", err)
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added || change.type == .modified {
                    let dictionary = change.document.data()
                    let recentMessage = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            })
            
            self.resetItems()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            listener?.remove()
        }
    }
    
    deinit {
        print("MatchesMessagesController is being deallocated....")
    }
    
    
    
    
    fileprivate func resetItems() {
        
        var values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: { ts1, ts2 in
            ts1.timestamp.compare(ts2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white

        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        collectionView.contentInset.top = 120
        collectionView.verticalScrollIndicatorInsets.top = 120
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
        fetchRecentMessages()
        
        
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
