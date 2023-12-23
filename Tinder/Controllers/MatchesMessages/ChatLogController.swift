//
//  ChatLogController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 17.12.2023.
//

import LBTATools
import UIKit
import Firebase



class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    //**********//
    //without lazy var it appears error bc no guarantee which one is created first.
    private lazy var customNavBar = MessageNavBar(match: match)

    
    private var match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    
    // Input Accessory View
    
    
    deinit {
        print("ChatLogController is being deallocated....")
    }
        
    
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    @objc fileprivate func handleSend() {
        
        saveToFromMessages()
        saveToFromRecentMessages()
    }
    
    fileprivate func saveToFromRecentMessages() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        var data: [String: Any] = ["text": customInputView.textView.text ?? "", "name": match.name, "profileImageUrl": match.profileImageUrl,"uid": match.uid, "timestamp": Timestamp(date: Date())]
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").document(match.uid).setData(data) { err in
            if let err = err {
                print("Failed to save recent messages", err)
                return
            }
            
            print("Save recent messages successfully")
            
        }
        
        
        //other User
        guard let currentUser = currentUser else {return}
        var toData: [String: Any] = ["text": customInputView.textView.text ?? "", "name": currentUser.name ?? "", "profileImageUrl": currentUser.image1Url ?? "","uid": currentUserId, "timestamp": Timestamp(date: Date())]
        
        Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(currentUserId).setData(toData) { err in
            if let err = err {
                print("Failed to save recent messages", err)
                return
            }
            
            print("Save recent messages successfully")
            
        }
    }
    
    fileprivate func saveToFromMessages() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        let collection = Firestore.firestore().collection("matches_messages").document(currentUserID).collection(match.uid)
        let data: [String: Any] = ["text": customInputView.textView.text, "fromID": currentUserID, "toID": match.uid, "timestamp": Timestamp(date: Date())]
        collection.addDocument(data: data) { err in
            if let err = err {
                print("Failed to save messages", err)
                return
            }
            print("Saved messages successfully...")
            self.customInputView.textView.text = nil
            self.customInputView.placeHolder.isHidden = false
        }
        
        let toCollection = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserID)
        toCollection.addDocument(data: data) { err in
            if let err = err {
                print("Failed to save messages", err)
                return
            }
            print("Saved messages successfully...")
            self.customInputView.textView.text = nil
            self.customInputView.placeHolder.isHidden = false
        }
    }
    
    
    override var inputAccessoryView: UIView? {
        
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
   
    var currentUser: User?
    
    fileprivate func fetchCurrentUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(currentUserId).getDocument { snapshot, err in
            if let err = err {
                print("Failed to get current user", err)
                return
            }
            
            print("Current user was fetched successfully")
            let dictionary: [String: Any] = snapshot?.data() ?? [:]
            self.currentUser = User(dictionary: dictionary)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
        collectionView.contentInset.top = 120
        collectionView.verticalScrollIndicatorInsets.top = 120
        collectionView.keyboardDismissMode = .interactive
        
        fetchMessages()
        fetchCurrentUser()
        
    }
    
    
    @objc fileprivate func handleShowKeyboard() {
        collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    
    var listener: ListenerRegistration?
    
    
    fileprivate func fetchMessages() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        let query = Firestore.firestore().collection("matches_messages").document(currentUserID).collection(match.uid).order(by: "timestamp")
        
        listener = query.addSnapshotListener { snapshot, err in
            if let err = err {
                print("Failed to get messages", err)
                return
            }
            
            print("Fetched messages successfully")
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            })
            
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            listener?.remove()
        }
    }
    
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // estimating Size
        
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
