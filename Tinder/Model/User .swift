//
//  User .swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 16.10.2023.
//

import UIKit


struct User: ProducesCardViewModel {
    
    var name: String?
    var age: Int?
    var profession: String?
    var image1Url: String?
    
    
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.image1Url = dictionary["image1Url"] as? String
        
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        
        return CardViewModel(imageNames: [image1Url ?? "" ], attributedString: attributedText, textAlignment: .left)
    }
    
}
