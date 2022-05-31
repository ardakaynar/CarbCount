//
//  FoodTableViewCell.swift
//  CarbCount
//
//  Created by SH Developer on 29.05.2022.
//

import UIKit
import DropDown

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vwDropDown: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var carbResult: UILabel!
    @IBOutlet weak var calculateCarb: UIButton!
    
    
    let viewModel = FoodsViewModel()
    var temp: Int = 100
    let dropDown = DropDown()
    let dropDownValues = ["Gram", "Adet", "Porsiyon"]
    
    @IBAction func calculateTapped(_ sender: Any) {
        carbResult.text = String(temp)
        temp += 100
        Store.shared.consumedCarbCount += 100
    }
    
    @IBAction func dropDownTapped(_ sender: Any) {
        dropDown.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "seç"
        dropDownSetup()
        setupUI()
    }
    
    func dropDownSetup() {
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.titleLabel.text = dropDownValues[index]
        }
    }
    
    func setupUI() {
        calculateCarb.tintColor = .white
        calculateCarb.backgroundColor = .red
        calculateCarb.layer.cornerRadius = 10
        foodCountTextField.placeholder = viewModel.textFieldPlaceHolder
    }
}
