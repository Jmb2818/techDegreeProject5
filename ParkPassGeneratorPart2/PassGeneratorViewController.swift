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
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var ssnLabel: UILabel!
    @IBOutlet weak var projectNumLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    
    
    lazy var  mainButtons: [UIButton] = [guestButton, employeeButton, managerButton, vendorButton]
    lazy var mainTextFields: [UITextField] = [dateOfBirthField, ssnField, projectField, firstNameField, lastNameField, companyField, addressField, cityField, stateField, zipCodeField]
    lazy var mainLabels: [UILabel] = [dobLabel, ssnLabel, projectNumLabel, firstNameLabel, lastNameLabel, companyLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel]
    
    
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
        
        for subView in entrantSubTypeStackView.subviews {
            if let button = subView as? UIButton {
                button.isSelected = false
            }
        }
        
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
                dimLabelsExcept(enabledLabels: [dobLabel])
            } else if selectedSubButton.titleLabel?.text == "Season Pass" {
                dimFieldsExcept(enabledTextFields: [firstNameField,lastNameField, addressField, cityField, stateField, zipCodeField, dateOfBirthField])
                dimLabelsExcept(enabledLabels: [firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel, dobLabel])
            } else if selectedSubButton.titleLabel?.text == "Senior" {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, firstNameField, lastNameField])
                dimLabelsExcept(enabledLabels: [dobLabel, firstNameLabel, lastNameLabel])
            } else {
                dimFieldsExcept(enabledTextFields: [])
                dimLabelsExcept(enabledLabels: [])
            }
        case "Employee":
            if selectedSubButton.titleLabel?.text == "Contract" {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField, projectField])
                dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel, projectNumLabel])
            } else {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField])
                dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel])
            }
        case "Manager":
            dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField])
            dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel])
        case "Vendor":
            dimFieldsExcept(enabledTextFields: [firstNameField, lastNameField, companyField, dateOfBirthField])
            dimLabelsExcept(enabledLabels: [firstNameLabel, lastNameLabel, companyLabel, dobLabel])
        default:
            break
        }
    }
    
    func dimFieldsExcept(enabledTextFields: [UITextField]) {
        for textField in mainTextFields {
            textField.isEnabled = false
            textField.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8392156863, blue: 0.8745098039, alpha: 1)
        }
        
        for textField in enabledTextFields {
            textField.isEnabled = true
            textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func dimLabelsExcept(enabledLabels: [UILabel]) {
        for label in mainLabels {
            label.isEnabled = false
        }
        for label in enabledLabels {
            label.isEnabled = true
        }
    }
    
    
    
    
}
