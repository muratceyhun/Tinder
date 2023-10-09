//
//  ViewController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 7.10.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        let subviews = [UIColor.gray, .darkGray, .black].map { color in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        
        let topStackView = UIStackView(arrangedSubviews: subviews)
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
        stackView.axis = .vertical
//        stackView.frame = .init(x: 0, y: 0, width: 300, height: 300)
        view.addSubview(stackView)
        stackView.fillSuperview()
//        stackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        
    }
}

