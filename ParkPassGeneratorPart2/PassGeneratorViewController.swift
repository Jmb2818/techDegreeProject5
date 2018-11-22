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
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var employeeButton: UIButton!
    @IBOutlet weak var managerButton: UIButton!
    @IBOutlet weak var vendorButton: UIButton!
    
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var ssnField: UITextField!
    @IBOutlet weak var projectField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    
    lazy var  mainButtons: [UIButton] = [guestButton, employeeButton, managerButton, vendorButton]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        layoutStackView(stackView: entrantTypeStackView)
    }
    
    
    @IBAction func entrantTypeSelection(_ sender: UIButton) {
        
        DispatchQueue.main.async { [ weak self] in
            guard let self = self else { return }
            
            for button in self.mainButtons {
                if button.isSelected {
                    button.isSelected = false
                }
            }
            sender.isSelected = true
            switch sender.restorationIdentifier {
            case EntrantType.Guest.rawValue:
                self.layoutStackView(entrantType: .Guest)
            case EntrantType.Employee.rawValue:
                self.layoutStackView(entrantType: .Employee)
            case EntrantType.Vendor.rawValue:
                self.layoutStackView(entrantType: .Vendor)
            case EntrantType.Manager.rawValue:
                self.layoutStackView(entrantType: .Manager)
            default:
                break
            }
        }
    }
    
    
    func layoutStackView(entrantType: EntrantType) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Remove any buttons that may already be in the stack view
            if !self.entrantSubTypeStackView.subviews.isEmpty {
                for view in self.entrantSubTypeStackView.subviews {
                    view.removeFromSuperview()
                }
            }
            
            switch entrantType {
            case .Manager:
                ManagerType.allCases.forEach {
                    let button = StackViewButton(title: $0.rawValue, view: self.entrantSubTypeStackView)
                    button.addTarget(self, action: #selector(self.layoutSubtype), for: .touchUpInside)
                    self.entrantSubTypeStackView.addArrangedSubview(button)
                }
            case .Employee:
                EmployeeType.allCases.forEach {
                    let button = StackViewButton(title: $0.rawValue, view: self.entrantSubTypeStackView)
                    button.addTarget(self, action: #selector(self.layoutSubtype), for: .touchUpInside)
                    self.entrantSubTypeStackView.addArrangedSubview(button)
                }
            case .Guest:
                GuestType.allCases.forEach {
                    let button = StackViewButton(title: $0.rawValue, view: self.entrantSubTypeStackView)
                    button.addTarget(self, action: #selector(self.layoutSubtype), for: .touchUpInside)
                    self.entrantSubTypeStackView.addArrangedSubview(button)
                }
            case .Vendor:
                VendorType.allCases.forEach {
                    let button = StackViewButton(title: $0.rawValue, view: self.entrantSubTypeStackView)
                    button.addTarget(self, action: #selector(self.layoutSubtype), for: .touchUpInside)
                    self.entrantSubTypeStackView.addArrangedSubview(button)
                }
            }
        }
    }
    
    @objc func layoutSubtype(sender: Any) {
        
        guard let selectedSubButton = sender as? UIButton else { return }
        
        selectedSubButton.isSelected = true
        
        var selectedButtonLabel: String?
        for button in mainButtons {
            if button.isSelected {
                selectedButtonLabel = button.titleLabel?.text
            }
        }
        
        guard let selectedButton = selectedButtonLabel else { return }
        
        switch selectedButton {
        case "Guest":
            if selectedSubButton.titleLabel?.text == "Child" {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField])
            } else if selectedSubButton.titleLabel?.text == "Season Pass" {
                dimFieldsExcept(enabledTextFields: [firstNameField,lastNameField, addressField, cityField, stateField, zipCodeField, dateOfBirthField])
            } else if selectedSubButton.titleLabel?.text == "Senior" {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, firstNameField, lastNameField])
            } else {
                dimFieldsExcept(enabledTextFields: [])
            }
        case "Employee":
            break
        case "Manager":
            break
        case "Vendor":
            break
        default:
            break
        }
    }
    
    func dimFieldsExcept(enabledTextFields: [UITextField]) {
        dateOfBirthField.isEnabled = false
        ssnField.isEnabled = false
        projectField.isEnabled = false
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        companyField.isEnabled = false
        addressField.isEnabled = false
        cityField.isEnabled = false
        stateField.isEnabled = false
        zipCodeField.isEnabled = false
        
        for textField in enabledTextFields {
            textField.isEnabled = true
        }
    }
    
    
    
    
}
