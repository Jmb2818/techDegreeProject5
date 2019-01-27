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
    
    // MARK: Properties
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
        // Remove observers on deinit
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: IBActions
    
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
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generatePass" {
            let destinationViewController = segue.destination as? PassViewController
            if let pass = generatePass() {
              destinationViewController?.passModel = GeneratedPassModel(from: pass)
            }
        }
    }
    
    // MARK: Helper Functions
    
    func resetPassGenerator() {
        
        // Reset all fields and labels back to their original state
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
    
    func createAlert(title: String = UserStrings.Error.generalTitle, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UserStrings.Error.okTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Pass Generation Functions
    
    func generatePass() -> Pass? {
        let passType = getSelectedPassType()
        let entrant = createEntrant()
        var pass: Pass?
        
        guard let passMainType = passType.mainType, let passSubType = passType.subType  else {
            createAlert(message: UserStrings.Error.errorWithType)
            return nil
        }
        
        do {
            switch passMainType {
            case .Employee:
                pass = try EmployeePass(entrant: entrant, employeeTypeString: passSubType)
            case .Guest:
                pass = try GuestPass(entrant: entrant, guestTypeString: passSubType)
            case .Manager:
                pass = try ManagerPass(entrant: entrant, managerTypeString: passSubType)
            case .Vendor:
                pass = try VendorPass(entrant: entrant, vendorTypeString: passSubType)
            }
            
        } catch(let error) {
            let generatorError = error as? GeneratorError ?? GeneratorError.generic
            createAlert(message: generatorError.getErrorMessage())
        }
        return pass
    }
    
    
    func createEntrant() -> Entrant {
        let entrant = Entrant(firstName: firstNameField.text,
                              lastName: lastNameField.text,
                              streetAddress: addressField.text,
                              city: cityField.text,
                              state: stateField.text,
                              zipCode: zipCodeField.text,
                              ssn: Formatter.formatNumberFromString(ssnField.text),
                              dob: Formatter.createDateOfBirthDate(fromString: dateOfBirthField.text),
                              projectNum: projectField.text)
        
        return entrant
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
    
    // MARK: Text field and stack view configuration functionsg
    
    func layoutStackView(entrantType: EntrantType) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Remove any buttons that may already be in the stack view
            if !self.entrantSubTypeStackView.subviews.isEmpty {
                for view in self.entrantSubTypeStackView.subviews {
                    view.removeFromSuperview()
                }
            }
            
            // Layout entrant subtype based on main type selected and give it the function
            // to layout the view's text fields
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
        // Unselect all of the buttons in the subType stack view
        for subView in entrantSubTypeStackView.subviews {
            if let button = subView as? UIButton {
                button.isSelected = false
            }
        }
        // Get the selected button and highlight it as being selected
        guard let selectedSubButton = sender as? UIButton else { return }
        
        selectedSubButton.isSelected = true
        
        var selectedButtonLabel: String?
        for button in mainButtons {
            if button.isSelected {
                selectedButtonLabel = button.titleLabel?.text
            }
        }
        // Depending on how which button is selected, configure the view's text fields
        guard let selectedButton = selectedButtonLabel else { return }
        
        switch selectedButton {
        case EntrantType.Guest.rawValue:
            if selectedSubButton.titleLabel?.text == GuestType.child.rawValue {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField])
                dimLabelsExcept(enabledLabels: [dobLabel])
            } else if selectedSubButton.titleLabel?.text == GuestType.seasonPass.rawValue {
                dimFieldsExcept(enabledTextFields: [firstNameField,lastNameField, addressField, cityField, stateField, zipCodeField, dateOfBirthField])
                dimLabelsExcept(enabledLabels: [firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel, dobLabel])
            } else if selectedSubButton.titleLabel?.text == GuestType.senior.rawValue {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, firstNameField, lastNameField])
                dimLabelsExcept(enabledLabels: [dobLabel, firstNameLabel, lastNameLabel])
            } else {
                dimFieldsExcept(enabledTextFields: [])
                dimLabelsExcept(enabledLabels: [])
            }
        case EntrantType.Employee.rawValue:
            if selectedSubButton.titleLabel?.text == EmployeeType.contract.rawValue {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField, projectField])
                dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel, projectNumLabel])
            } else {
                dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField])
                dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel])
            }
        case EntrantType.Manager.rawValue:
            dimFieldsExcept(enabledTextFields: [dateOfBirthField, ssnField, firstNameField, lastNameField, addressField, cityField, stateField, zipCodeField])
            dimLabelsExcept(enabledLabels: [dobLabel, ssnLabel, firstNameLabel, lastNameLabel, addressLabel, cityLabel, stateLabel, zipCodeLabel])
        case EntrantType.Vendor.rawValue:
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
                    textField.text = UserStrings.MockData.firstName
                case "lastName":
                    textField.text = UserStrings.MockData.lastName
                case "company":
                    textField.text = UserStrings.MockData.company
                case "dob":
                    textField.text = UserStrings.MockData.dob
                case "ssn#":
                    textField.text = UserStrings.MockData.ssn
                case "project#":
                    textField.text = UserStrings.MockData.projectNum
                case "streetAddress":
                    textField.text = UserStrings.MockData.streetAddress
                case "city":
                    textField.text = UserStrings.MockData.city
                case "state":
                    textField.text = UserStrings.MockData.state
                case "zipCode":
                    textField.text = UserStrings.MockData.zipcode
                default:
                    break
                }
            }
        }
    }
    
    // MARK: Keyboard hiding logic
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let largeIpadScreenSize: CGFloat = 1024
        
        guard !shouldResizeForKeyboard() && view.bounds.width < largeIpadScreenSize else { return }
        // Move the view up to not hide the bottom text fields with the keyboard
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0.0
        }
    }
    
    func shouldResizeForKeyboard() -> Bool {
        return dateOfBirthField.isEditing || ssnField.isEditing || projectField.isEditing || firstNameField.isEditing || lastNameField.isEditing || companyField.isEditing
    }
}

extension PassGeneratorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
