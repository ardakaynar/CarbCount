//
//  FoodAppendViewController.swift
//  CarbCount
//
//  Created by SH Developer on 18.06.2022.
//

import UIKit
import RealmSwift

class FoodAppendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var perGramLabel: UILabel!
    @IBOutlet weak var perGramTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var pickPhotoButton: UIButton!
    
    let viewModel = FoodAppendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perGramTextField.delegate = self
        setupUI()
        foodImageView.isHidden = true
    }
    
    func setupUI() {
        titleLabel.text = viewModel.titleLabelText
        descriptionLabel.text = viewModel.descriptionLabelText
        
        foodNameLabel.text = viewModel.foodNameLabel
        foodNameTextField.placeholder = viewModel.foodNameTextFieldPlaceHolder
        
        perGramLabel.text = viewModel.foodPerGramLabel
        perGramTextField.placeholder = viewModel.foodPerGramTextFieldPlaceHolder
        
       
        addButton.setTitle(viewModel.buttonText, for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor(red: 110/255.0, green: 184/255.0, blue: 168/255.0, alpha: 1.00)
        addButton.layer.cornerRadius = 5
        
        
        pickPhotoButton.setTitle(viewModel.pickPhotoText, for: .normal)
        pickPhotoButton.tintColor = .white
        pickPhotoButton.backgroundColor = UIColor(red: 110/255.0, green: 184/255.0, blue: 168/255.0, alpha: 1.00)
        pickPhotoButton.layer.cornerRadius = 5
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        if foodNameTextField.text == "", perGramTextField.text == "", foodImageView.isHidden {
            let dialogMessage = UIAlertController(title: "Lütfen Eksik Alanları Doldurunuz!", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                print("Count button tapped")
             })
            dialogMessage.addAction(ok)
            foodNameTextField.layer.borderWidth = 2
            foodNameTextField.layer.borderColor = CGColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
            perGramTextField.layer.borderWidth = 2
            perGramTextField.layer.borderColor = CGColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        if foodNameTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Ürün İsmini Giriniz!", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                print("Count button tapped")
             })
            dialogMessage.addAction(ok)
            foodNameTextField.layer.borderWidth = 2
            foodNameTextField.layer.borderColor = CGColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        if perGramTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Karbonhidrat Miktarını Giriniz!", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                print("Count button tapped")
             })
            dialogMessage.addAction(ok)
            perGramTextField.layer.borderWidth = 2
            perGramTextField.layer.borderColor = CGColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        if foodImageView.isHidden {
            let dialogMessage = UIAlertController(title: "Resim Yükleyiniz!", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                print("Count button tapped")
             })
            dialogMessage.addAction(ok)
           
            self.present(dialogMessage, animated: true, completion: nil)
        }
        insertFoodData()
        
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickPhotoTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func insertFoodData() {
        app.login(credentials: Credentials.anonymous) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                    // Continue below
                }
                
                // mongodb-atlas is the cluster service name
                let client = app.currentUser!.mongoClient("mongodb-atlas")
                // Select the database
                let database = client.database(named: "userTest")
                // Select the collection
                let collection = database.collection(withName: "foodTable")
                let tempString: AnyBSON = self.foodNameTextField.text
                let food: Document = [ "FoodName": tempString as AnyBSON, "CarbPerGram": "Timbio, Colombia", "containsDairy": "false", "_partition": "Store 43"]
                collection.insertOne(food) { result in
                    switch result {
                    case .failure(let error):
                        print("Call to MongoDB failed: \(error.localizedDescription)")
                        return
                    case .success(let objectId):
                        // Success returns the objectId for the inserted document
                        print("Successfully inserted a document with id: \(objectId)")
                    }
                }
    
            }
        }
    }
    
}

extension FoodAppendViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        foodImageView.isHidden = false
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            foodImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
