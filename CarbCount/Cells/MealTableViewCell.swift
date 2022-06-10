//
//  MealTableViewCell.swift
//  CarbCount
//
//  Created by SH Developer on 9.06.2022.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDateLabel: UILabel!
    @IBOutlet weak var carbResultLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
