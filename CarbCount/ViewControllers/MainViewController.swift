//
//  MainViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var lastFeedItemLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var remainingCarbLabel: UILabel!
    @IBOutlet weak var carbDescriptionLabel: UILabel!
    
    let viewModel = MainViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 350.0, height: 350.0))
        cp.trackColor = UIColor.green
        cp.progressColor = UIColor.orange
        cp.tag = 101
        self.circularView.addSubview(cp)
        //cp.progressLayer.strokeEnd = 0.8
        
    }
    
    @objc func animateProgress() {
        let cP = self.view.viewWithTag(101) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 1 / Float((Store.shared.dailyCarbCount / Store.shared.consumedCarbCount)))
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.greetingLabel.text = "Hoşgeldin \(Store.shared.name) !"
            self.perform(#selector(self.animateProgress), with: nil, afterDelay: 0.2)
            self.remainingCarbLabel.text = "\(Int(Store.shared.consumedCarbCount)) gr / \(Int(Store.shared.dailyCarbCount)) gr"
            self.resetConsumedCarb()
        })
    }
    
    func setupUI() {
        configureAccesibility()
        setupNavBar()
    }
    
    func configureAccesibility() {
        lastFeedItemLabel.text = viewModel.lastFeedLabel
        carbDescriptionLabel.text = "Tüketilen Karbonhidrat Miktarı"
       
    }
    
    func setupNavBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBlue
        barAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
     
        self.navigationItem.title = "Anasayfa"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func resetConsumedCarb() {
        let resetTime = "235959"
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
    
        let currentTime = "\(hour)\(minutes)\(seconds)"
        if currentTime == resetTime {
            Store.shared.consumedCarbCount = 0.0
            remainingCarbLabel.text = "\(Int(Store.shared.consumedCarbCount)) gr / \(Int(Store.shared.dailyCarbCount)) gr"
        }
    }


}

