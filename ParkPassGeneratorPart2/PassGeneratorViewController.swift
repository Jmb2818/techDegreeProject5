//
//  PassGeneratorViewController.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/14/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class PassGeneratorViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var entrantTypeStackView: UIStackView!
    @IBOutlet weak var entrantSubTypeStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        layoutStackView(stackView: entrantTypeStackView)
    }
    
    func layoutStackView(stackView: UIStackView) {
        // Remove any buttons that may already be in the stack view
        if !stackView.subviews.isEmpty {
            for view in stackView.subviews {
                view.removeFromSuperview()
            }
        }
        
        EntrantType.allCases.forEach {
            let button = StackViewButton(title: $0.rawValue, view: stackView)
            button.addTarget(self, action: #selector(layoutSubtype), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
    }
    
    @objc func layoutSubtype() {
        print("Layed out SubType")
    }
    
    
}
