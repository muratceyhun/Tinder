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

struct CardViewModel {
    
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
}
