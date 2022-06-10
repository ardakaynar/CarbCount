//
//  ProfileViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {

// MARK: - Outlets
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var infoCarbCalculateLabel: UILabel!
    @IBOutlet weak var infoCarbLabel: UILabel!
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
        doneButton.tintColor = .blue
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
        Store.shared.birthDate = birthDateTextField.text!
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
        
        nameTextField.text = "\(Store.shared.name)"
        surnameTextField.text = "\(Store.shared.surname)"
        ageTextField.text = "\(Store.shared.age) yaşında"
        birthDateTextField.text = "\(Store.shared.birthDate)"
        weightTextField.text = "\(Store.shared.weight)"
        heightTextField.text = "\(Store.shared.height)"
        if Store.shared.isMale {
            maleButton.isSelected = true
            femaleButton.isSelected = false
        } else {
            femaleButton.isSelected = true
            maleButton.isSelected = false
        }
        countButton.tintColor = .white
        countButton.backgroundColor = UIColor(red: 110/255.0, green: 184/255.0, blue: 168/255.0, alpha: 1.00)
        
        infoCarbLabel.text = viewModel.infoCarbLabel
        infoCarbLabel.textColor = .gray
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(infoCarbTapped(sender:)))
        infoCarbLabel.addGestureRecognizer(tabGesture)
        
        infoCarbCalculateLabel.text = viewModel.infoCarbCalculateLabel
        infoCarbCalculateLabel.textColor = .gray
        let tabGesture2 = UITapGestureRecognizer(target: self, action: #selector(infoCarbCalculateTapped(sender:)))
        infoCarbCalculateLabel.addGestureRecognizer(tabGesture2)
        
    }
    
    @objc func infoCarbTapped(sender: UITapGestureRecognizer) {
        let viewController = InfoCarbViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func infoCarbCalculateTapped(sender: UITapGestureRecognizer) {
        let viewController2 = CarbCalculateInfoViewController()
        present(viewController2, animated: true, completion: nil)
    }
    
    func setupNavBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
        barAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
     
        self.navigationItem.title = "Profil"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func calculateCarb() {
        let weight: Double = Double(Store.shared.weight) ?? 0
        if Store.shared.age > 15 && Store.shared.age <= 18 {
            Store.shared.dailyCarbCount = Store.shared.isMale ? (17.6 * weight) + 656 : (13.3 * weight) + 690
        } else if Store.shared.age > 18 && Store.shared.age <= 30 {
            Store.shared.dailyCarbCount =  Store.shared.isMale ? (18.0 * weight) + 690 : (14.8 * weight) + 485
        } else if Store.shared.age > 30 && Store.shared.age <= 60 {
            Store.shared.dailyCarbCount =  Store.shared.isMale ? (11.4 * weight) + 870 : (8.1 * weight) + 842
        } else {
            Store.shared.dailyCarbCount =  Store.shared.isMale ? (11.7 * weight) + 585 : (9.0 * weight) + 656
        }
        
    }
    
    func saveProfileInfos() {
        Store.shared.name = nameTextField.text!
        Store.shared.surname = surnameTextField.text!
        Store.shared.height = heightTextField.text!
        Store.shared.weight = weightTextField.text!
    }

// MARK: - Actions
    
    @IBAction func calculateCarbCount(_ sender: UIButton) {
        saveProfileInfos()
        calculateCarb()
        Store.shared.consumedCarbCount = 0
        let dialogMessage = UIAlertController(title: "Karbonhidrat Miktarı", message: "Merhaba \(Store.shared.name)!\n Günlük tüketmen gereken karbonhidrat miktarı \(Int(Store.shared.dailyCarbCount)) gr kadardır.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
            print("Count button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            maleButton.isSelected = true
            femaleButton.isSelected = false
            Store.shared.isMale = true
        } else if sender.tag == 1 {
            maleButton.isSelected = false
            femaleButton.isSelected = true
            Store.shared.isMale = false
        }
    }
   
    
}
