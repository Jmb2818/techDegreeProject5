//
//  PassViewController.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 12/6/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class PassViewController: UIViewController {
    
    @IBOutlet weak var passFullNameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var rideStatusLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchDiscountLabel: UILabel!
    @IBOutlet weak var swipeResultLabel: UILabel!
    @IBOutlet weak var swipeMessage: UILabel!
    @IBOutlet weak var swipePassResultView: UIView!
    
    
    var pass: Pass?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pass = pass {
            
            passFullNameLabel.text = pass.fullName
            passTypeLabel.text = pass.passType
            foodDiscountLabel.text = "• Food \(pass.swipe(discountOn: .food).message)"
            merchDiscountLabel.text = "• Merchandise \(pass.swipe(discountOn: .food).message)"

        }
    }
    
    @IBAction func dismissPassViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkPass(_ sender: UIButton) {
        
        guard let pass = pass else { return }
        AreaAccess.allCases.forEach { current in
            if sender.restorationIdentifier == current.rawValue {
                checkSwipeResult(pass.swipe(for: current))
            }
        }
        DiscountAccess.allCases.forEach { current in
            if sender.restorationIdentifier == current.rawValue {
                checkSwipeResult(pass.swipe(discountOn: current))
            }
        }
        if sender.restorationIdentifier == "rideAccess" {
            checkSwipeResult(pass.swipe(rideAccess: .all))
        }
    }
    
    func checkSwipeResult(_ swipeResult: SwipeResult) {
        
        if swipeResult.access == true {
            swipePassResultView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            swipePassResultView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
        swipeResultLabel.text = swipeResult.description
        swipeMessage.text = swipeResult.message
        swipeResultLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        swipeMessage.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
}
