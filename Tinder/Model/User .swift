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
    var image2Url: String?
    var image3Url: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.image1Url = dictionary["image1Url"] as? String
        self.image2Url = dictionary["image2Url"] as? String
        self.image3Url = dictionary["image3Url"] as? String
        self.uid = dictionary["uid"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int 
        
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        
        if let url = image1Url {
            imageUrls.append(url)
        }
        if let url = image2Url {
            imageUrls.append(url)
        }
        if let url = image3Url {
            imageUrls.append(url)
        }
        
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
    
}
