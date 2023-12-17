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
    let isFormCurrnetUser: Bool
}



class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.9019607902, green: 0.9019607902, blue: 0.9019607902, alpha: 1))

    
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFormCurrnetUser {
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.0861729607, green: 0.7602494955, blue: 0.998857677, alpha: 1)
                textView.textColor = .white
                
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9019607902, green: 0.9019607902, blue: 0.9019607902, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.constant = -20

        
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
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
    
    
    // Input Accessory View
    
    
    class CustomInputAccessoryView: UIView {
        
        let textView = UITextView()
        lazy var sendButton = UIButton(title: "Send", titleColor: .black, target: self, action: #selector(handleSend))
        
        let placeHolder = UILabel(text: "Placeholder here", font: .systemFont(ofSize: 16), textColor: .lightGray)
        
        
        override var intrinsicContentSize: CGSize {
           return .zero
        }
        

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            setupShadow(opacity: 0.3, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
            autoresizingMask = .flexibleHeight
      
            
            textView.text = ""
            textView.font = .systemFont(ofSize: 16)
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            
            
            //*********//
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
            
            
            
            hstack(textView, sendButton.withSize(.init(width: 60, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
            
            addSubview(placeHolder)
            placeHolder.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 0))
            placeHolder.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        }
        
        @objc fileprivate func handleTextChange() {
            placeHolder.isHidden = textView.text.count != 0
        }
        
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
        
    
    lazy var redView: CustomInputAccessoryView = {
        return CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 64))
    }()
    
    @objc fileprivate func handleSend() {
        
    }
    
    override var inputAccessoryView: UIView? {
        
        get {
            return redView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
   
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
        collectionView.contentInset.top = 120
        collectionView.verticalScrollIndicatorInsets.top = 120
        collectionView.keyboardDismissMode = .interactive
        
        items =
        [
            .init(text: "I just can't seem to understand , Thought it was me and you, babe babe Me and you until the end But I guess I was wrong uh I just can't seem to understand , Thought it was me and you, babe babe Me and you until the end But I guess I was wrong uh", isFormCurrnetUser: true),
            .init(text: "Good bro, what about you ?, Good bro, what about you ?", isFormCurrnetUser: false),
            .init(text: "Nice to hear that !", isFormCurrnetUser: true),
            .init(text: "Don't want to think about it (uh) Don't want to talk about it uh I'm just so sick about it Can't believe it's ending this way Just so confused about it (uh) Feeling the blues about yeah I just can't do without ya But tell me is this fair?", isFormCurrnetUser: false),
            .init(text: "Don't want to think about it (uh) Don't want to talk about it uh I'm just so sick about it Can't believe it's ending this way Just so confused about it (uh) Feeling the blues about yeah I just can't do without ya But tell me is this fair? ay Just so confused about it (uh) Feeling the blues about yeah I just can't do without ya But tell me is this ", isFormCurrnetUser: true)
        
        ]
        
        
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
