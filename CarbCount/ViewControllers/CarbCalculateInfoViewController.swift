//
//  CarbCalculateInfoViewController.swift
//  CarbCount
//
//  Created by SH Developer on 9.06.2022.
//

import UIKit

class CarbCalculateInfoViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let viewModel = CarbCalculateInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = viewModel.titleLabel
        descriptionLabel.text = viewModel.descriptionLabel
        dismissButton.tintColor = .black
        
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
