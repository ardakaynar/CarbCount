//
//  FoodTableViewCell.swift
//  CarbCount
//
//  Created by SH Developer on 29.05.2022.
//

import UIKit
import DropDown

class FoodTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var vwDropDown: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var carbResult: UILabel!
    @IBOutlet weak var calculateCarb: UIButton!
    var tapHandler: (() -> ())?
    var addHandler: (() -> ())?
    var indexHandler: ((Int) -> (Int))?
    
    var viewModel: FoodsViewModel? {
             didSet {
                 configure()
             }
         }
   
    var temp: Int = 100
    let dropDown = DropDown()
    var dropDownValues: [String] = []
    var defaultValues: [String] = []
    var perGramValue: Double = 0.0
    var perSessionValue: Double = 0.0
    var indexPath: Int = 0
    var isPerGram: Bool = true
    var enabledAmountTypes: [Int] = []
    func configure() {
        guard let viewModel = viewModel else { return }
        self.perGramValue = FoodsViewController.foodData[viewModel.indexPath!].carbPerGram
        self.perSessionValue = FoodsViewController.foodData[viewModel.indexPath!].carbPerSession
        self.enabledAmountTypes = FoodsViewController.foodData[viewModel.indexPath!].enabledAmountTypes
        self.indexPath = viewModel.indexPath!
        carbResult.text = String(Float(perGramValue))
       
        calculateCarb.tintColor = .white
        calculateCarb.backgroundColor = UIColor(red: 42/255.0, green: 88/255.0, blue: 80/255.0, alpha: 1.00)
        calculateCarb.isUserInteractionEnabled = false
        calculateCarb.layer.cornerRadius = 10
        foodCountTextField.placeholder = viewModel.textFieldPlaceHolder
        setDropdownValues()
        dropDownSetup()
    }

    func setDropdownValues() {
        dropDownValues.removeAll()
       
        for value in enabledAmountTypes {
            switch value {
            case 0:
                dropDownValues.append("Gram")
                defaultValues.append("100")
                isPerGram = true
            case 1:
                dropDownValues.append("Kilogram")
                defaultValues.append("1")
                isPerGram = true
            case 2:
                dropDownValues.append("Mililitre")
                defaultValues.append("100")
                isPerGram = true
            case 3:
                dropDownValues.append("Litre")
                defaultValues.append("1")
                isPerGram = true
            case 4:
                dropDownValues.append("Porsiyon")
                defaultValues.append("1")
                isPerGram = false
            case 5:
                dropDownValues.append("Adet")
                defaultValues.append("1")
                isPerGram = false
            case 6:
                dropDownValues.append("Bardak")
                defaultValues.append("1")
                isPerGram = false
            default:
                dropDownValues.append("Gram")
                defaultValues.append("1")
                isPerGram = true
            }
        }
    }
 
    @IBAction func foodCountTextFieldDidEnd(_ sender: Any) {
        carbResult.text = "\(Float(Double(self.foodCountTextField.text ?? "")! * self.perGramValue))"
        
    }
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        tapHandler?()
        Store.shared.consumedCarbCount += Double(carbResult.text ?? "")!
        addHandler?()
    }
    
    @IBAction func dropDownTapped(_ sender: Any) {
        dropDown.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        foodCountTextField.delegate = self
    
       
      
    }
    
    func dropDownSetup() {
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.titleLabel.text = dropDownValues[index]
            self.foodCountTextField.text = defaultValues[index]
            self.calculateCarb.backgroundColor = UIColor(red: 116/255.0, green: 200/255.0, blue: 63/255.0, alpha: 1.00)
            self.calculateCarb.isUserInteractionEnabled = true
            
            self.carbResult.text = isPerGram ? "\(Float(Double(self.foodCountTextField.text ?? "")! * self.perGramValue))" : "\(Float(Double(self.foodCountTextField.text ?? "")! * self.perSessionValue))"
        }
        titleLabel.text = "Birim"
        titleLabel.backgroundColor = UIColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
        titleLabel.layer.cornerRadius = 10
        titleLabel.textColor = .white
        dropDownButton.layer.cornerRadius = 10
        vwDropDown.layer.cornerRadius = 10
    }
    
    
}
