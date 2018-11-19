//
//  StackViewButton.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/15/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class StackViewButton: UIButton {

    // Initialize button for the stack view so they are all the same
    
    convenience init(title: String, view: UIStackView) {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        self.setTitle(title, for: .normal)
        self.setTitleColor(#colorLiteral(red: 0.8196078431, green: 0.7568627451, blue: 0.8823529412, alpha: 1), for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .highlighted)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.4274509804, blue: 0.6666666667, alpha: 1)
        tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
