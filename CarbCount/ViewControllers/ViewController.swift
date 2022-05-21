//
//  ViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var circularView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 350.0, height: 350.0))
        cp.trackColor = UIColor.green
        cp.progressColor = UIColor.orange
        self.circularView.addSubview(cp)
        cp.progressLayer.strokeEnd = 1.0
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.greetingLabel.text = "Merhaba \(Store.shared.name) !\(Store.shared.dailyCarbCount)"
        })
    }
    
    func setupUI() {
        configureAccesibility()
        setupNavBar()
    }
    
    func configureAccesibility() {
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = .black
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Anasayfa"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }


}

