//
//  CardViewModel.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 17.10.2023.
//

import UIKit


protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment

    fileprivate var imageIndex = 0 {
        didSet {
            
            let imageUrl = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceNextPhoto() {
        imageIndex = min(imageIndex + 1 , imageUrls.count - 1 )
        
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}
