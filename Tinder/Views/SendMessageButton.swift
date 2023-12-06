//
//  SendMessageButton.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 6.12.2023.
//

import UIKit

class SendMessageButtom: UIButton {
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9773893952, green: 0.1316288412, blue: 0.4395705462, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9867201447, green: 0.4110130072, blue: 0.3139508367, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
//        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = rect
    }
    
}
