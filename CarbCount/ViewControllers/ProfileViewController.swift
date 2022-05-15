//
//  ProfileViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var surnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    func configure() {
        nameTextField.placeholder = "İsim"
        surnameTextField.placeholder = "Soyisim"
        countButton.tintColor = .white
        countButton.backgroundColor = .red
    }

    @IBAction func calculateCarbCount(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Karbonhidrat Miktarı", message: "\(nameTextField.text!) gün içerisinde tüketebileceğin karbonhidrat miktarı: \(surnameTextField.text!)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
            print("Count button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
