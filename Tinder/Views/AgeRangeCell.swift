//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 11.11.2023.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            .init(width: 80, height: 0)
        }
    }
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel: UILabel = {
       let label = AgeRangeLabel()
        return label
    }()
    
    let maxLabel: UILabel = {
       let label = AgeRangeLabel()
        return label
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true

        let overallStackView = UIStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [minLabel, minSlider]), UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
