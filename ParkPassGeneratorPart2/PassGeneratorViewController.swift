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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        for field in mainTextFields {
            field.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetPassGenerator()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @IBAction func populateData(_ sender: UIButton) {
        fillFields()
    }
    
    
    func resetPassGenerator() {
        for field in mainTextFields {
            field.text?.removeAll()
            dimFieldsExcept(enabledTextFields: [])
        }
        dimLabelsExcept(enabledLabels: [])
        for button in mainButtons {
            button.isSelected = false
        }
        for view in entrantSubTypeStackView.subviews {
            view.removeFromSuperview()
        }
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: entrantSubTypeStackView.frame.width, height: entrantSubTypeStackView.frame.height))
        emptyView.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.2117647059, blue: 0.2823529412, alpha: 1)
        entrantSubTypeStackView.addSubview(emptyView)
    }
    
    func generatePass() -> Pass? {
        let passType = getSelectedPassType()
        let entrant = createEntrant()
        var pass: Pass?
        
        guard let passMainType = passType.mainType, let passSubType = passType.subType  else {
            createAlert()
            return nil
        }
        
        
        switch passMainType {
        case .Employee:
            do {
                let _pass = try EmployeePass(entrant: entrant, employeeTypeString: passSubType)
                pass = _pass
            } catch(let error) {
                print(error)
                createAlert()
            }
        case .Guest:
            do {
                let _pass = try GuestPass(entrant: entrant, guestTypeString: passSubType)
                pass = _pass
            } catch(let error) {
                createAlert()
            }
        case .Manager:
            do {
                let _pass = try ManagerPass(entrant: entrant, managerTypeString: passSubType)
                pass = _pass
            } catch(let error) {
                createAlert()
            }
        case .Vendor:
            do {
                let _pass = try VendorPass(entrant: entrant, vendorTypeString: passSubType)
                pass = _pass
            } catch(let error) {
                createAlert()
            }
        }
        return pass
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generatePass" {
            let destinationViewController = segue.destination as? PassViewController
            destinationViewController?.pass = generatePass()
        }
    }
    
    func createAlert() {
        let alert = UIAlertController(title: "Hello", message: "Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.resetPassGenerator()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createEntrant() -> Entrant {
        // TODO: Maybe throw an error if ssn or date cannot be created
        let entrant = Entrant(firstName: firstNameField.text,
                lastName: lastNameField.text,
                streetAddress: addressField.text,
                city: cityField.text,
                state: stateField.text,
                zipCode: zipCodeField.text,
                ssn: formatNumberFromString(ssnField.text),
                dob: DateEditor.createDateOfBirthDate(fromString: dateOfBirthField.text))
        
        return entrant
    }
    
    
    func formatNumberFromString(_ stringNum: String?) -> Int? {
        if let numberString = stringNum {
            let numNoOtherChar = numberString.components(separatedBy:
                CharacterSet.decimalDigits.inverted).joined(separator: "")
            return Int(numNoOtherChar)
        }
        return nil
    }
    
    func getSelectedPassType() -> (mainType: EntrantType?,subType: String?) {
        var passType: (mainType: EntrantType?,subType: String?)
        for button in mainButtons {
            if button.isSelected {
                EntrantType.allCases.forEach { current in
                    if let buttonTitle = button.currentTitle, current.rawValue == buttonTitle {
                        passType.mainType = current
                    }
                }
            }
        }
        
        for subView in entrantSubTypeStackView.subviews {
            if let button = subView as? UIButton {
                if button.isSelected {
                    passType.subType = button.currentTitle
                }
            }
        }
        
        return passType
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
    
    func fillFields() {
        for textField in mainTextFields {
            if textField.isEnabled {
                switch textField.restorationIdentifier {
                case "firstName":
                    textField.text = "Harry"
                case "lastName":
                    textField.text = "Potter"
                case "company":
                    textField.text = "Acme"
                case "dob":
                    textField.text = "10/31/1981"
                case "ssn#":
                    textField.text = "345-43-1234"
                case "project#":
                    textField.text = "1001"
                case "streetAddress":
                    textField.text = "300 Hogwarts Way"
                case "city":
                    textField.text = "Hogsmeade"
                case "state":
                    textField.text = "Scotland"
                case "zipCode":
                    textField.text = "40453"
                default:
                    break
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // TODO: check screen size
        guard !dateOfBirthField.isEditing,
            !ssnField.isEditing,
            !projectField.isEditing,
            !firstNameField.isEditing,
            !lastNameField.isEditing,
            !companyField.isEditing
            else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension PassGeneratorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
