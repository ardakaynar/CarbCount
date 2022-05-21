//
//  ProfileViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {

// MARK: - Outlets
    
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    
 // MARK: - Variables
    
    let viewModel = ProfileViewModel()
    let datePicker = UIDatePicker()

// MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = .green
        toolbar.setItems([spacer, doneButton], animated: true)
        birthDateTextField.inputAccessoryView = toolbar
        datePicker.date = viewModel.maxDate
        datePicker.datePickerMode = .date
        datePicker.maximumDate = viewModel.maxDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        birthDateTextField.inputView = datePicker
        birthDateTextField.placeholder = viewModel.birthdayPlaceholder
        birthDateTextField.tintColor = .clear
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        formatter.dateFormat = "dd.MM.yyyy"
        birthDateTextField.text = formatter.string(from: datePicker.date)
        Store.shared.age = calculateAge(dateOfBirth: datePicker.date)
        ageTextField.text = "\(Store.shared.age) yaşında"
        self.view.endEditing(true)
    }
    
    func calculateAge(dateOfBirth: Date) -> Int {
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date())
        return Int(ageComponents.year!)
    }
    
    func setupUI() {
        configure()
        setupNavBar()
    }
    
    func configure() {
        nameTextField.placeholder = viewModel.namePlaceholder
        surnameTextField.placeholder = viewModel.surnamePlaceholder
        ageTextField.placeholder = viewModel.agePlaceholder
        heightTextField.placeholder = viewModel.heightPlaceholder
        weightTextField.placeholder = viewModel.weightPlaceholder
        
        countButton.tintColor = .white
        countButton.backgroundColor = .red
    }
    
    func setupNavBar() {
        self.navigationItem.title = viewModel.navigationTitle
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func calculateCarb() {
        Store.shared.dailyCarbCount = 1200.0
    }

// MARK: - Actions
    
    @IBAction func calculateCarbCount(_ sender: UIButton) {
        Store.shared.name = nameTextField.text!
        Store.shared.surname = surnameTextField.text!
        calculateCarb()
        let dialogMessage = UIAlertController(title: "Karbonhidrat Miktarı", message: "Merhaba \(nameTextField.text!) \(surnameTextField.text!), Kilon: \(weightTextField.text!) Boyun: \(heightTextField.text!) Yaşın: \(ageTextField.text!)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
            print("Count button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
