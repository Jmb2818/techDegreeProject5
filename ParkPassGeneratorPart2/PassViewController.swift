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
    @IBOutlet weak var passResultLabel: UILabel!
    
    var pass: Pass?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pass = pass {
            // TODO: Add a full name to pass
            passFullNameLabel.text = "\(pass.entrant.firstName ?? "") \(pass.entrant.lastName ?? "")"
            passTypeLabel.text = pass.passType

        }
    }
    
    @IBAction func dismissPassViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
